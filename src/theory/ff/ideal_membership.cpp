/******************************************************************************
 * This file is part of the cvc5 project.
 *
 * Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
 * in the top-level source directory and their institutional affiliations.
 * All rights reserved.  See the file COPYING in the top-level source
 * directory for licensing information.
 * ****************************************************************************
 *
 * Ideal-membership strategies for finite-field polynomials.
 */

#ifdef CVC5_USE_COCOA

#include "theory/ff/ideal_membership.h"

// external includes
#include <CoCoA/SparsePolyIter.H>
#include <CoCoA/SparsePolyOps-MinPoly.H>
#include <CoCoA/SparsePolyOps-RingElem.H>
#include <CoCoA/SparsePolyOps-ideal.H>
#include <CoCoA/SparsePolyRing.H>
#include <CoCoA/TmpGPoly.H>

// std includes
#include <unordered_set>
#include <utility>

namespace cvc5::internal {
namespace theory {
namespace ff {

CocoaIdealMembership::CocoaIdealMembership() : d_ideal() {}
CocoaIdealMembership::CocoaIdealMembership(const Polys& generators) : d_ideal()
{
  if (!generators.empty())
  {
    d_ideal.emplace(CoCoA::ideal(generators));
  }
}

bool CocoaIdealMembership::contains(const Poly& p) const
{
  return d_ideal.has_value() && CoCoA::IsElem(p, d_ideal.value());
}

Poly CocoaIdealMembership::reduce(const Poly& p) const
{
  return d_ideal.has_value() ? CoCoA::NF(p, d_ideal.value()) : p;
}

Gb::Gb() : CocoaIdealMembership(), d_basis() {}
Gb::Gb(const Polys& generators, const ResourceManager* rm)
    : CocoaIdealMembership(generators), d_basis()
{
  if (d_ideal.has_value())
  {
    d_basis = GBasisTimeout(d_ideal.value(), rm);
  }
}

bool Gb::isWholeRing() const
{
  return d_ideal.has_value() && CoCoA::IsOne(d_ideal.value());
}

bool Gb::zeroDimensional() const
{
  return d_ideal.has_value() && CoCoA::IsZeroDim(d_ideal.value());
}

Poly Gb::minimalPolynomial(const Poly& var) const
{
  Assert(zeroDimensional());
  Assert(CoCoA::UnivariateIndetIndex(var) != -1);
  return CoCoA::MinPolyQuot(var, *d_ideal, var);
}

const Polys& Gb::basis() const { return d_basis; }

PowerDifferenceIdealMembership::PowerDifferenceIdealMembership(
    const Polys& generators,
    const ResourceManager* rm,
    MixedIdealStrategy strategy)
{
  Polys genericGenerators = generators;
  // The tracer needs CoCoA's reduction callbacks for derived polynomials.
  if (!CoCoA::handlersEnabled)
  {
    while (true)
    {
      const size_t previousRuleCount = d_powerRules.size();
      genericGenerators = extractPowerRules(genericGenerators);

      Polys reducedGenerators;
      for (const Poly& g : genericGenerators)
      {
        Poly reduced = hasPowerDifferenceRules() ? reducePowerRules(g) : g;
        if (!CoCoA::IsZero(reduced))
        {
          reducedGenerators.push_back(reduced);
        }
      }
      genericGenerators = std::move(reducedGenerators);

      // Reduction may expose another power rule. Repeat until it does not.
      if (d_powerRules.size() == previousRuleCount)
      {
        break;
      }
    }
  }

  if (genericGenerators.empty())
  {
    return;
  }

  if (strategy == MixedIdealStrategy::COMPLETE_GB && hasPowerDifferenceRules())
  {
    // Exact mixed membership includes both the power rules and the reduced
    // generic generators in one Groebner-basis computation.
    Polys completeGenerators;
    for (const PowerRule& rule : d_powerRules)
    {
      completeGenerators.push_back(rule.d_generator);
    }
    completeGenerators.insert(completeGenerators.end(),
                              genericGenerators.begin(),
                              genericGenerators.end());
    d_remainderMembership = std::make_unique<Gb>(completeGenerators, rm);
    return;
  }

  // The default relaxation keeps the custom power basis separate and builds
  // membership only for the reduced generic ideal. It can miss membership
  // that depends on interactions between the two parts.
  d_remainderMembership =
      std::make_unique<CocoaIdealMembership>(genericGenerators);
}

Polys PowerDifferenceIdealMembership::extractPowerRules(const Polys& generators)
{
  // Partition generators into arithmetic rewrite rules and a generic remainder.
  Polys genericGenerators;
  std::unordered_set<size_t> variables;
  for (const PowerRule& rule : d_powerRules)
  {
    // Rules discovered in earlier passes reserve their variables.
    variables.insert(rule.d_variable);
  }
  for (const Poly& g : generators)
  {
    if (CoCoA::IsZero(g))
    {
      // A zero generator imposes no constraint and can be discarded.
      continue;
    }
    if (!CoCoA::IsField(CoCoA::CoeffRing(CoCoA::owner(g))))
    {
      // Normalizing the leading coefficient requires field division.
      genericGenerators.push_back(g);
      continue;
    }
    if (CoCoA::NumTerms(g) != 2)
    {
      // A power-difference rule must have exactly two monomial terms.
      genericGenerators.push_back(g);
      continue;
    }
    auto it = CoCoA::BeginIter(g);
    std::vector<CoCoA::BigInt> high;
    CoCoA::BigExponents(high, CoCoA::PP(it));
    Scalar leading = CoCoA::coeff(it);
    ++it;
    std::vector<CoCoA::BigInt> low;
    CoCoA::BigExponents(low, CoCoA::PP(it));
    size_t variable = high.size();
    for (size_t i = 0; i < high.size(); ++i)
    {
      if (!CoCoA::IsZero(high[i]))
      {
        if (variable != high.size())
        {
          // The leading monomial contains more than one variable.
          variable = high.size();
          break;
        }
        // Remember the sole variable occurring in the leading monomial.
        variable = i;
      }
    }
    if (variable == high.size())
    {
      // Constant or multivariate leading monomials are not power rules.
      genericGenerators.push_back(g);
      continue;
    }
    if (high[variable] <= low[variable])
    {
      // Rewriting must strictly lower the exponent of the rule variable.
      genericGenerators.push_back(g);
      continue;
    }
    bool isSameVariable = true;
    for (size_t i = 0; i < low.size(); ++i)
    {
      if (i != variable && !CoCoA::IsZero(low[i]))
      {
        // The lower monomial may contain only the same rule variable.
        isSameVariable = false;
        break;
      }
    }
    if (!isSameVariable)
    {
      genericGenerators.push_back(g);
      continue;
    }
    if (!variables.insert(variable).second)
    {
      // Multiple relations for one variable can interact, so keep later ones
      // in the generic remainder instead of treating them as independent.
      genericGenerators.push_back(g);
      continue;
    }
    // Normalize x^high + c*x^low into x^high = scale*x^low.
    d_powerRules.push_back({variable,
                            high[variable],
                            low[variable],
                            -CoCoA::coeff(it) / leading,
                            g / leading});
  }
  return genericGenerators;
}

void PowerDifferenceIdealMembership::applyPowerRules(
    std::vector<CoCoA::BigInt>& exponents, Scalar& coefficient) const
{
  for (const PowerRule& rule : d_powerRules)
  {
    Assert(rule.d_variable < exponents.size());
    rule.apply(exponents[rule.d_variable], coefficient);
  }
}

Poly PowerDifferenceIdealMembership::reducePowerRules(const Poly& p) const
{
  Assert(hasPowerDifferenceRules());
  // CoCoA's owner is the polynomial ring; a rule is valid only in that ring.
  Assert(CoCoA::owner(p) == CoCoA::owner(d_powerRules.front().d_generator));
  const CoCoA::SparsePolyRing ring = CoCoA::owner(p);
  Poly result = CoCoA::zero(ring);
  for (auto it = CoCoA::BeginIter(p); !CoCoA::IsEnded(it); ++it)
  {
    std::vector<CoCoA::BigInt> exponents;
    CoCoA::BigExponents(exponents, CoCoA::PP(it));
    Scalar coefficient = CoCoA::coeff(it);
    applyPowerRules(exponents, coefficient);

    // Reconstruct one sparse term; polynomial addition collects collisions.
    result += CoCoA::monomial(
        ring, coefficient, CoCoA::PPMonoidElem(CoCoA::PPM(ring), exponents));
  }
  return result;
}

bool PowerDifferenceIdealMembership::contains(const Poly& p) const
{
  Poly reduced = hasPowerDifferenceRules() ? reducePowerRules(p) : p;
  return d_remainderMembership ? d_remainderMembership->contains(reduced)
                               : CoCoA::IsZero(reduced);
}

Poly PowerDifferenceIdealMembership::reduce(const Poly& p) const
{
  Poly reduced = hasPowerDifferenceRules() ? reducePowerRules(p) : p;
  return d_remainderMembership ? d_remainderMembership->reduce(reduced)
                               : reduced;
}

}  // namespace ff
}  // namespace theory
}  // namespace cvc5::internal

#endif /* CVC5_USE_COCOA */
