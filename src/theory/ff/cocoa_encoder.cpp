/******************************************************************************
 * This file is part of the cvc5 project.
 *
 * Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
 * in the top-level source directory and their institutional affiliations.
 * All rights reserved.  See the file COPYING in the top-level source
 * directory for licensing information.
 * ****************************************************************************
 *
 * encoding Nodes as cocoa ring elements.
 */

#ifdef CVC5_USE_COCOA

#include "theory/ff/cocoa_encoder.h"

// external includes
#include <CoCoA/BigInt.H>
#include <CoCoA/PPMonoidEv.H>
#include <CoCoA/QuotientRing.H>
#include <CoCoA/SparsePolyIter.H>
#include <CoCoA/SparsePolyOps-RingElem.H>
#include <CoCoA/SparsePolyRing.H>

// std includes
#include <algorithm>
#include <sstream>

// internal includes
#include "expr/node_traversal.h"
#include "theory/ff/cocoa_util.h"
#include "theory/theory.h"

namespace cvc5::internal {
namespace theory {
namespace ff {

namespace {

/**
 * Raise a monomial without expanding it or converting its exponent to long.
 * This is the compact path needed for cryptographic-size power differences.
 */
Poly powerMonomial(const Poly& base, const CoCoA::BigInt& exponent)
{
  const CoCoA::ring& ring = CoCoA::owner(base);
  if (CoCoA::IsZero(exponent))
  {
    return CoCoA::one(ring);
  }
  if (CoCoA::IsZero(base))
  {
    return CoCoA::zero(ring);
  }
  if (!CoCoA::IsMonomial(base))
  {
    // General polynomial powers use CoCoA's ordinary expansion. Large such
    // powers are inherently unsuitable for this sparse-polynomial encoding.
    return cocoaPower(base, exponent);
  }

  CoCoA::SparsePolyIter it = CoCoA::BeginIter(base);
  std::vector<CoCoA::BigInt> exponents;
  CoCoA::BigExponents(exponents, CoCoA::PP(it));
  for (CoCoA::BigInt& e : exponents)
  {
    e *= exponent;
  }
  return CoCoA::monomial(ring,
                         cocoaPower(CoCoA::coeff(it), exponent),
                         CoCoA::PPMonoidElem(CoCoA::PPM(ring), exponents));
}

}  // namespace

#define LETTER(c) (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z'))

// CoCoA symbols must start with a letter and contain only letters, numbers, and
// underscores.
//
// Our encoding is described within
CoCoA::symbol cocoaSym(const std::string& varName, std::optional<size_t> index)
{
  std::ostringstream o;
  for (const auto c : varName)
  {
    // letters and numbers as themselves
    uint8_t code = c;
    if (LETTER(c) || ('0' <= c && c <= '9'))
    {
      o << c;
    }
    // _ as __
    else if ('_' == c)
    {
      o << "__";
    }
    // other as _xXX (XX is hex)
    else
    {
      o << "_x"
        << "0123456789abcdef"[code & 0x0f]
        << "0123456789abcdef"[(code >> 4) & 0x0f];
    }
  }
  // if we're starting with something bad, prepend u__; note that the above
  // never produces __.
  std::string s = o.str();
  if (!LETTER(s[0]))
  {
    s.insert(0, "u__");
  }
  return index.has_value() ? CoCoA::symbol(s, *index) : CoCoA::symbol(s);
}

CocoaEncoder::CocoaEncoder(NodeManager* nm,
                           const FfSize& size,
                           DisequalityMode disequalityMode)
    : FieldObj(nm, size), d_disequalityMode(disequalityMode)
{
}

CoCoA::symbol CocoaEncoder::freshSym(const std::string& varName,
                                     std::optional<size_t> index)
{
  Trace("ff::cocoa::sym") << "CoCoA sym for " << varName;
  if (index.has_value())
  {
    Trace("ff::cocoa::sym") << "[" << *index << "]";
  }
  Trace("ff::cocoa::sym") << std::endl;
  Assert(d_stage == Stage::Scan);
  std::optional<size_t> suffix = {};
  CoCoA::symbol sym("dummy");
  std::string symString;
  do
  {
    std::string n = suffix.has_value()
                        ? varName + "_" + std::to_string(suffix.value())
                        : varName;
    sym = cocoaSym(n, index);
    symString = extractStr(sym);
    if (suffix.has_value())
    {
      *suffix += 1;
    }
    else
    {
      suffix = std::make_optional(0);
    }
  } while (d_vars.count(symString));
  d_vars.insert(symString);
  d_syms.push_back(sym);
  return sym;
}

void CocoaEncoder::endScan()
{
  Assert(d_stage == Stage::Scan);
  d_stage = Stage::Encode;
  d_coeffRing = CoCoA::NewZZmod(intToCocoa(size()));
  const bool hasPower =
      std::any_of(d_scanned.begin(), d_scanned.end(), [](const Node& node) {
        return node.getKind() == Kind::FINITE_FIELD_POW;
      });
  if (hasPower)
  {
    // Power-difference constraints can contain exponents as large as p^2.
    CoCoA::PPMonoid ppm = CoCoA::NewPPMonoidEv(
        d_syms, CoCoA::StdDegRevLex, CoCoA::PPExpSize::big);
    d_polyRing = CoCoA::NewPolyRing(*d_coeffRing, ppm);
  }
  else
  {
    // CoCoA's Groebner algorithms require the default small-exponent monoid.
    d_polyRing = CoCoA::NewPolyRing(*d_coeffRing, d_syms);
  }
  for (size_t i = 0, n = d_syms.size(); i < n; ++i)
  {
    d_symPolys.insert({extractStr(d_syms[i]), CoCoA::indet(*d_polyRing, i)});
  }
}

void CocoaEncoder::addFact(const Node& fact)
{
  Assert(isFfFact(fact, size()));
  if (d_stage == Stage::Scan)
  {
    for (const auto& node :
         NodeDfsIterable(fact, VisitOrder::POSTORDER, [this](TNode nn) {
           return d_scanned.count(nn);
         }))
    {
      if (!d_scanned.insert(node).second)
      {
        continue;
      }
      if (isFfLeaf(node, size()) && !node.isConst())
      {
        Trace("ff::cocoa") << "CoCoA var sym for " << node << std::endl;
        CoCoA::symbol sym = freshSym(node.getName());
        Assert(!d_varSyms.count(node));
        Assert(!d_symNodes.count(extractStr(sym)));
        d_varSyms.insert({node, sym});
        d_symNodes.insert({extractStr(sym), node});
      }
      else if (node.getKind() == Kind::NOT && isFfFact(node, size())
               && d_disequalityMode == DisequalityMode::INVERSE_WITNESS)
      {
        Trace("ff::cocoa") << "CoCoA != sym for " << node << std::endl;
        CoCoA::symbol sym = freshSym("diseq", d_diseqSyms.size());
        d_diseqSyms.insert({node, sym});
      }
      else if (node.getKind() == Kind::FINITE_FIELD_BITSUM)
      {
        Trace("ff::cocoa") << "CoCoA bitsum sym for " << node << std::endl;
        CoCoA::symbol sym = freshSym("bitsum", d_bitsumSyms.size());
        d_bitsumSyms.insert({node, sym});
        d_symNodes.insert({extractStr(sym), node});
      }
    }
  }
  else
  {
    Assert(d_stage == Stage::Encode);
    encodeFact(fact);
    if (fact.getKind() == Kind::NOT
        && d_disequalityMode == DisequalityMode::MEMBERSHIP_TARGET)
    {
      d_membershipTargets.push_back(d_cache.at(fact));
    }
    else
    {
      d_polys.push_back(d_cache.at(fact));
    }
  }
}

void CocoaEncoder::addMembershipTarget(const Node& target)
{
  Assert(d_disequalityMode == DisequalityMode::MEMBERSHIP_TARGET);
  Assert(target.getKind() == Kind::EQUAL);
  if (d_stage == Stage::Scan)
  {
    addFact(target);
    return;
  }
  Assert(d_stage == Stage::Encode);
  encodeFact(target);
  d_membershipTargets.push_back(d_cache.at(target));
}

std::vector<Node> CocoaEncoder::bitsums() const
{
  std::vector<Node> bs;
  for (const auto& [b, _] : d_bitsumSyms)
  {
    bs.push_back(b);
  }
  return bs;
}

const Node& CocoaEncoder::symNode(CoCoA::symbol s) const
{
  Assert(d_symNodes.count(extractStr(s)));
  return d_symNodes.at(extractStr(s));
}

bool CocoaEncoder::hasNode(CoCoA::symbol s) const
{
  return d_symNodes.count(extractStr(s));
}

std::vector<std::pair<size_t, Node>> CocoaEncoder::nodeIndets() const
{
  std::vector<std::pair<size_t, Node>> out;
  for (size_t i = 0, end = d_syms.size(); i < end; ++i)
  {
    if (hasNode(d_syms[i]))
    {
      Node n = symNode(d_syms[i]);
      // skip indets for !=
      if (isFfLeaf(n, size()))
      {
        out.emplace_back(i, n);
      }
    }
  }
  return out;
}

FiniteFieldValue CocoaEncoder::cocoaFfToFfVal(const Scalar& elem) const
{
  Assert(d_coeffRing.has_value());
  Assert(CoCoA::owner(elem) == d_coeffRing);
  return ff::cocoaFfToFfVal(elem, size());
}

const Node& CocoaEncoder::polyFact(const Poly& poly) const
{
  return d_polyFacts.at(extractStr(poly));
}

bool CocoaEncoder::polyHasFact(const Poly& poly) const
{
  return d_polyFacts.count(extractStr(poly));
}

const Poly& CocoaEncoder::symPoly(CoCoA::symbol s) const
{
  Assert(d_symPolys.count(extractStr(s)));
  return d_symPolys.at(extractStr(s));
}

void CocoaEncoder::encodeTerm(const Node& t)
{
  Assert(d_stage == Stage::Encode);

  // for all un-encoded descendents:
  for (const auto& node :
       NodeDfsIterable(t, VisitOrder::POSTORDER, [this](TNode nn) {
         return d_cache.count(nn);
       }))
  {
    // a rule must put the encoding here
    Poly elem;
    if (isFfFact(node, size()) || isFfTerm(node, size()))
    {
      Trace("ff::cocoa::enc") << "Encode " << node;
      // ff leaf
      if (isFfLeaf(node, size()) && !node.isConst())
      {
        elem = symPoly(d_varSyms.at(node));
      }
      // ff.add
      else if (node.getKind() == Kind::FINITE_FIELD_ADD)
      {
        elem = CoCoA::zero(*d_polyRing);
        for (const auto& c : node)
        {
          elem += d_cache[c];
        }
      }
      // ff.neg
      else if (node.getKind() == Kind::FINITE_FIELD_NEG)
      {
        elem = -d_cache[node[0]];
      }
      // ff.mul
      else if (node.getKind() == Kind::FINITE_FIELD_MULT)
      {
        elem = CoCoA::one(*d_polyRing);
        for (const auto& c : node)
        {
          elem *= d_cache[c];
        }
      }
      // ((_ ff.pow n) x)
      else if (node.getKind() == Kind::FINITE_FIELD_POW)
      {
        const Integer& exponent =
            node.getOperator().getConst<FiniteFieldPower>().d_exponent;
        elem = powerMonomial(d_cache[node[0]], intToCocoa(exponent));
      }
      // ff.bitsum
      else if (node.getKind() == Kind::FINITE_FIELD_BITSUM)
      {
        Poly sum = CoCoA::zero(*d_polyRing);
        Poly two = CoCoA::one(*d_polyRing) * 2;
        Poly twoPow = CoCoA::one(*d_polyRing);
        for (const auto& c : node)
        {
          sum += twoPow * d_cache[c];
          twoPow *= two;
        }
        elem = symPoly(d_bitsumSyms.at(node));
        d_bitsumPolys.push_back(sum - elem);
      }
      // ff constant
      else if (node.getKind() == Kind::CONST_FINITE_FIELD)
      {
        elem = CoCoA::one(*d_polyRing)
               * intToCocoa(node.getConst<FiniteFieldValue>().getValue());
      }
      // !!
      else
      {
        Unimplemented() << node;
      }
    }
    // cache the encoding
    d_cache.insert({node, elem});
  }
}

void CocoaEncoder::encodeFact(const Node& f)
{
  Assert(d_stage == Stage::Encode);
  Assert(isFfFact(f, size()));
  Poly p;
  // ==
  if (f.getKind() == Kind::EQUAL)
  {
    encodeTerm(f[0]);
    encodeTerm(f[1]);
    p = d_cache.at(f[0]) - d_cache.at(f[1]);
  }
  // !=
  else
  {
    encodeTerm(f[0][0]);
    encodeTerm(f[0][1]);
    Poly diff = d_cache.at(f[0][0]) - d_cache.at(f[0][1]);
    p = d_disequalityMode == DisequalityMode::INVERSE_WITNESS
            ? diff * symPoly(d_diseqSyms.at(f)) - 1
            : diff;
  }
  if (!CoCoA::IsZero(p))
  {
    // normalize; if we don't do it, CoCoA will in GB input, confusing our
    // tracer.
    p = p / CoCoA::LC(p);
  }
  d_cache.insert({f, p});
  d_polyFacts.insert({extractStr(p), f});
}

}  // namespace ff
}  // namespace theory
}  // namespace cvc5::internal

#endif /* CVC5_USE_COCOA */
