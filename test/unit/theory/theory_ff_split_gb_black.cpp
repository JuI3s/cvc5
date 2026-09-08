/******************************************************************************
 * This file is part of the cvc5 project.
 *
 * Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
 * in the top-level source directory and their institutional affiliations.
 * All rights reserved.  See the file COPYING in the top-level source
 * directory for licensing information.
 * ****************************************************************************
 *
 * Black box testing of ff multivariate roots.
 */

#ifdef CVC5_USE_COCOA
#include <CoCoA/BigInt.H>
#include <CoCoA/PPMonoidEv.H>
#include <CoCoA/QuotientRing.H>
#include <CoCoA/RingZZ.H>
#include <CoCoA/SparsePolyOps-RingElem.H>
#include <CoCoA/SparsePolyOps-ideal.H>
#include <CoCoA/SparsePolyRing.H>
#include <CoCoA/ring.H>
#include <CoCoA/symbol.H>

#include <memory>
#include <utility>

#include "test_env.h"
#include "theory/ff/ideal_membership.h"
#include "theory/ff/multi_roots.h"
#include "theory/ff/split_gb.h"
#include "util/cocoa_globals.h"
#include "util/random.h"
#include "util/resource_manager.h"

namespace cvc5::internal {

using namespace kind;
using namespace context;
using namespace theory;

namespace test {

class TestTheoryFfSplitGb : public TestEnv
{
  void SetUp() override
  {
    TestEnv::SetUp();
    initCocoaGlobalManager();
  }
};

CoCoA::RingElem randCoeff(const CoCoA::ring& polyRing, Random& rng)
{
  return CoCoA::zero(CoCoA::CoeffRing(polyRing)) + rng.pick<uint64_t>();
}

CoCoA::RingElem randPoly(const CoCoA::ring& polyRing,
                         size_t degree,
                         size_t terms,
                         Random& rng)
{
  CoCoA::RingElem out = CoCoA::zero(polyRing);
  for (size_t ti = 0; ti < terms; ++ti)
  {
    CoCoA::RingElem term = CoCoA::zero(polyRing) + randCoeff(polyRing, rng);
    long tDegree = 1 + (rng.pick<uint64_t>() % degree);
    for (long i = 0; i < tDegree; ++i)
    {
      long j = rng.pick<uint64_t>() % CoCoA::NumIndets(polyRing);
      term *= CoCoA::indet(polyRing, j);
    }
    out += term;
  }
  return out;
}

CoCoA::RingElem randPolyWithRoot(const CoCoA::ring& polyRing,
                                 size_t degree,
                                 size_t terms,
                                 std::vector<CoCoA::RingElem> root,
                                 Random& rng)
{
  CoCoA::RingElem p = randPoly(polyRing, degree, terms, rng);
  CoCoA::RingElem val = ff::cocoaEval(p, root);
  return p - val;
}

TEST_F(TestTheoryFfSplitGb, RandSat)
{
  // two bases, random, always SAT
  size_t n_vars = 6;
  size_t degree = 2;
  size_t n_bases = 2;
  size_t n_terms = 2;
  size_t n_eqns = 1.5 * static_cast<double>(n_vars);
  size_t n_iters = 50;
  size_t modulus = 11;
  CoCoA::ring ring = CoCoA::NewZZmod(modulus);
  std::vector<CoCoA::symbol> syms = CoCoA::SymbolRange("x", 0, n_vars - 1);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(ring, syms);
  Random rng{0};
  for (size_t iter_i = 0; iter_i < n_iters; ++iter_i)
  {
    std::vector<CoCoA::RingElem> solution{};
    for (size_t i = 0; i < n_vars; ++i)
    {
      solution.push_back(randCoeff(polyRing, rng));
    }
    std::vector<std::vector<CoCoA::RingElem>> gens(n_bases);
    std::vector<CoCoA::RingElem> allGens;
    for (size_t i = 0; i < n_eqns; ++i)
    {
      allGens.push_back(
          randPolyWithRoot(polyRing, degree, n_terms, solution, rng));
      size_t j = rng.pick<uint64_t>() % n_bases;
      gens[j].push_back(allGens.back());
    }
    std::vector<ff::Gb> bases;
    for (size_t i = 0; i < n_bases; ++i)
    {
      bases.emplace_back(gens[i], nullptr);
    }
    ff::BitProp nullBitProp{};
    bool isSat = ff::findZero(CoCoA::ideal(allGens), *d_env).size();
    ff::SplitGb splitBases(bases);
    auto result =
        ff::splitFindZero(std::move(splitBases), polyRing, nullBitProp, *d_env);
    ASSERT_EQ(result.has_value(), isSat);
    if (result.has_value())
    {
      ff::checkZero(bases, *result);
    }
  }
}

TEST_F(TestTheoryFfSplitGb, RandUnsat)
{
  size_t n_vars = 6;
  size_t degree = 2;
  size_t n_bases = 2;
  size_t n_terms = 1;
  size_t n_eqns = 1.5 * static_cast<double>(n_vars);
  size_t n_iters = 40;
  size_t modulus = 11;
  CoCoA::ring ring = CoCoA::NewZZmod(modulus);
  std::vector<CoCoA::symbol> syms = CoCoA::SymbolRange("x", 0, n_vars - 1);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(ring, syms);
  Random rng{0};
  for (size_t iter_i = 0; iter_i < n_iters; ++iter_i)
  {
    std::vector<std::vector<CoCoA::RingElem>> gens(n_bases);
    std::vector<CoCoA::RingElem> allGens;
    for (size_t i = 0; i < n_eqns; ++i)
    {
      allGens.push_back(randPoly(polyRing, degree, n_terms, rng));
      size_t j = rng.pick<uint64_t>() % n_bases;
      gens[j].push_back(allGens.back());
    }
    std::vector<ff::Gb> bases;
    for (size_t i = 0; i < n_bases; ++i)
    {
      bases.emplace_back(gens[i], nullptr);
    }
    ff::BitProp nullBitProp{};
    bool isSat = ff::findZero(CoCoA::ideal(allGens), *d_env).size();
    ff::SplitGb splitBases(bases);
    auto result =
        ff::splitFindZero(std::move(splitBases), polyRing, nullBitProp, *d_env);
    ASSERT_EQ(result.has_value(), isSat);
    if (result.has_value())
    {
      ff::checkZero(bases, *result);
    }
  }
}

TEST_F(TestTheoryFfSplitGb, GbEmpty)
{
  size_t n_vars = 6;
  size_t modulus = 7;
  CoCoA::ring ring = CoCoA::NewZZmod(modulus);
  std::vector<CoCoA::symbol> syms = CoCoA::SymbolRange("x", 0, n_vars - 1);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(ring, syms);

  // empty vector
  ff::Gb gb{std::vector<CoCoA::RingElem>(), nullptr};
  ASSERT_FALSE(gb.isWholeRing());
  ASSERT_FALSE(gb.zeroDimensional());
  ASSERT_EQ(gb.basis().size(), 0);
  for (size_t i = 0; i < n_vars; ++i)
  {
    ASSERT_FALSE(gb.contains(CoCoA::indet(polyRing, i)));
  }

  // no args
  ff::Gb gb2{};
  ASSERT_FALSE(gb2.isWholeRing());
  ASSERT_FALSE(gb2.zeroDimensional());
  ASSERT_EQ(gb2.basis().size(), 0);
  for (size_t i = 0; i < n_vars; ++i)
  {
    ASSERT_FALSE(gb2.contains(CoCoA::indet(polyRing, i)));
  }
}

TEST_F(TestTheoryFfSplitGb, GbRand)
{
  size_t n_vars = 6;
  size_t degree = 2;
  size_t n_terms = 2;
  size_t n_eqns = 4;
  size_t n_iters = 200;
  size_t modulus = 11;
  CoCoA::ring ring = CoCoA::NewZZmod(modulus);
  std::vector<CoCoA::symbol> syms = CoCoA::SymbolRange("x", 0, n_vars - 1);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(ring, syms);
  Random rng{0};
  for (size_t iter_i = 0; iter_i < n_iters; ++iter_i)
  {
    std::vector<CoCoA::RingElem> gens;
    for (size_t i = 0; i < n_eqns; ++i)
    {
      gens.push_back(randPoly(polyRing, degree, n_terms, rng));
    }
    CoCoA::ideal i(gens);
    ff::Gb gb(gens, nullptr);
    ASSERT_EQ(gb.isWholeRing(), CoCoA::IsZero(i));
    ASSERT_EQ(gb.zeroDimensional(), CoCoA::IsZeroDim(i));
    ASSERT_EQ(gb.basis().size(), CoCoA::GBasis(i).size());
    for (const auto& p : gb.basis())
    {
      ASSERT_TRUE(CoCoA::IsElem(p, i));
    }
    for (const auto& p : CoCoA::GBasis(i))
    {
      ASSERT_TRUE(gb.contains(p));
    }
  }
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceConstantRule)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  ff::PowerDifferenceIdealMembership gb{{CoCoA::power(x, 4) + 1}, nullptr};

  ASSERT_TRUE(gb.hasPowerDifferenceRules());
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 13)), -x);
  ASSERT_TRUE(gb.contains(CoCoA::power(x, 13) + x));
  ASSERT_FALSE(gb.contains(CoCoA::power(x, 13) - x));
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 5) * y + x * y), 0);
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 5) * y - x * y), -2 * x * y);
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceScaledRule)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  ff::PowerDifferenceIdealMembership gb{
      {CoCoA::power(x, 5) + CoCoA::power(x, 2)}, nullptr};

  ASSERT_TRUE(gb.hasPowerDifferenceRules());
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 8)), CoCoA::power(x, 2));
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 11)), -CoCoA::power(x, 2));
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 13)), -CoCoA::power(x, 4));
  ASSERT_TRUE(gb.contains(CoCoA::power(x, 11) + CoCoA::power(x, 2)));
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceMultipleVariables)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  ff::PowerDifferenceIdealMembership gb{
      {CoCoA::power(x, 4) + 1, CoCoA::power(y, 3) - 2}, nullptr};

  ASSERT_TRUE(gb.hasPowerDifferenceRules());
  ASSERT_EQ(gb.reduce(CoCoA::power(x, 5) * CoCoA::power(y, 4)), -2 * x * y);
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceMatchesGeneralReduction)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  std::vector<CoCoA::RingElem> generators{
      CoCoA::power(x, 4) + 1,
      CoCoA::power(y, 5) + CoCoA::power(y, 2),
  };
  CoCoA::ideal ideal(generators);
  ff::PowerDifferenceIdealMembership gb{generators, nullptr};

  for (long xExponent = 0; xExponent < 20; ++xExponent)
  {
    for (long yExponent = 0; yExponent < 20; ++yExponent)
    {
      CoCoA::RingElem input = (xExponent + 2 * yExponent + 1)
                              * CoCoA::power(x, xExponent)
                              * CoCoA::power(y, yExponent);
      ASSERT_EQ(gb.reduce(input), CoCoA::NF(input, ideal));
    }
  }
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceCryptographicPrimeSubfields)
{
  const std::vector<std::pair<const char*, const char*>> fields{
      {"secp256k1 base field",
       "1157920892373161954235709850086879078532699846656405640394575840"
       "07908834671663"},
      {"Curve25519 base field",
       "5789604461865809771178549250434395392663499233282028201972879200"
       "3956564819949"},
      {"BN254 scalar field",
       "2188824287183927522224640574525727508854836440041603434369820418"
       "6575808495617"},
      {"BLS12-381 scalar field",
       "5243587517512619047944774050818596583769055250052763782260365869"
       "9938581184513"},
      {"BLS12-381 base field",
       "4002409555221667393417789825735904156556882819939007885332058136"
       "124031650490837864442687629129015664037894272559787"},
  };
  for (const auto& [name, modulus] : fields)
  {
    SCOPED_TRACE(name);
    const CoCoA::BigInt p = CoCoA::BigIntFromString(modulus);
    CoCoA::ring coeffRing = CoCoA::NewZZmod(p);
    std::vector<CoCoA::symbol> syms = CoCoA::symbols("x");
    CoCoA::PPMonoid ppm =
        CoCoA::NewPPMonoidEv(syms, CoCoA::StdDegRevLex, CoCoA::PPExpSize::big);
    CoCoA::SparsePolyRing polyRing = CoCoA::NewPolyRing(coeffRing, ppm);
    CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
    auto powerWithBigExponent = [&](const CoCoA::BigInt& exponent) {
      return CoCoA::monomial(
          polyRing,
          CoCoA::PPMonoidElem(ppm, std::vector<CoCoA::BigInt>{exponent}));
    };
    ff::PowerDifferenceIdealMembership membership{{powerWithBigExponent(p) - x},
                                                  nullptr};

    ASSERT_TRUE(membership.hasPowerDifferenceRules());
    // The roots of x^p - x in an extension of F_p are exactly its F_p
    // subfield. Applying Frobenius twice therefore still fixes every root.
    const CoCoA::BigInt pSquared = p * p;
    ASSERT_EQ(membership.reduce(powerWithBigExponent(pSquared)), x);
    ASSERT_TRUE(membership.contains(powerWithBigExponent(pSquared) - x));

    // The reducer handles an arbitrary huge exponent in one arithmetic step
    // instead of iterating once per use of x^p = x.
    const CoCoA::BigInt exponent = pSquared + 17 * p + 23;
    ASSERT_EQ(membership.reduce(powerWithBigExponent(exponent)),
              CoCoA::power(x, 41));
  }
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceMixedIdeal)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  std::vector<CoCoA::RingElem> generators{CoCoA::power(x, 2) - 1, x * y};
  CoCoA::ideal ideal(generators);
  ff::PowerDifferenceIdealMembership relaxed{generators, nullptr};
  ff::PowerDifferenceIdealMembership complete{
      generators,
      nullptr,
      ff::PowerDifferenceIdealMembership::MixedIdealStrategy::COMPLETE_GB};

  ASSERT_TRUE(relaxed.hasPowerDifferenceRules());
  // The default generic-only relaxation misses this power/generic interaction.
  ASSERT_FALSE(relaxed.contains(y));
  ASSERT_EQ(relaxed.reduce(y), y);
  ASSERT_TRUE(complete.contains(y));
  ASSERT_EQ(complete.reduce(y), CoCoA::NF(y, ideal));
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceReducesGenericGenerators)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  std::vector<CoCoA::RingElem> generators{
      CoCoA::power(x, 4) + 1,
      CoCoA::power(x, 9) * y + y,
  };
  CoCoA::ideal ideal(generators);
  ff::PowerDifferenceIdealMembership relaxed{generators, nullptr};
  ff::PowerDifferenceIdealMembership complete{
      generators,
      nullptr,
      ff::PowerDifferenceIdealMembership::MixedIdealStrategy::COMPLETE_GB};

  ASSERT_TRUE(relaxed.hasPowerDifferenceRules());
  ASSERT_TRUE(relaxed.contains((x + 1) * y));
  ASSERT_FALSE(relaxed.contains(y));
  for (long xExponent = 0; xExponent < 10; ++xExponent)
  {
    for (long yExponent = 0; yExponent < 10; ++yExponent)
    {
      CoCoA::RingElem input =
          CoCoA::power(x, xExponent) * CoCoA::power(y, yExponent) + x + y;
      ASSERT_EQ(complete.reduce(input), CoCoA::NF(input, ideal));
    }
  }
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceExtractsRulesToFixedPoint)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y,z"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  CoCoA::RingElem z = CoCoA::indet(polyRing, 2);

  // x^2 = 1 lowers the second generator to y^3 - y, exposing a new
  // power rule. That rule then lowers the first generator to yz + z^2.
  std::vector<CoCoA::RingElem> generators{
      CoCoA::power(y, 5) * z + CoCoA::power(z, 2),
      CoCoA::power(x, 2) * CoCoA::power(y, 3) - y,
      CoCoA::power(x, 2) - 1,
  };
  CoCoA::ideal ideal(generators);
  ff::PowerDifferenceIdealMembership relaxed{generators, nullptr};
  ff::PowerDifferenceIdealMembership complete{
      generators,
      nullptr,
      ff::PowerDifferenceIdealMembership::MixedIdealStrategy::COMPLETE_GB};

  ASSERT_TRUE(relaxed.hasPowerDifferenceRules());
  ASSERT_TRUE(relaxed.contains(CoCoA::power(y, 3) - y));
  ASSERT_TRUE(relaxed.contains(y * z + CoCoA::power(z, 2)));
  for (long xExponent = 0; xExponent < 8; ++xExponent)
  {
    for (long yExponent = 0; yExponent < 10; ++yExponent)
    {
      CoCoA::RingElem input =
          CoCoA::power(x, xExponent) * CoCoA::power(y, yExponent) * z;
      ASSERT_EQ(complete.reduce(input), CoCoA::NF(input, ideal));
    }
  }
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceMixedWholeRing)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing = CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  ff::PowerDifferenceIdealMembership gb{
      {CoCoA::power(x, 2) - 1, CoCoA::power(x, 2)}, nullptr};

  ASSERT_TRUE(gb.hasPowerDifferenceRules());
  ASSERT_TRUE(gb.contains(CoCoA::one(polyRing)));
}

TEST_F(TestTheoryFfSplitGb, PowerDifferenceFallsBackToGeneralGb)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  ff::PowerDifferenceIdealMembership gb{{x * y - 1, x - y}, nullptr};

  ASSERT_FALSE(gb.hasPowerDifferenceRules());
  ASSERT_TRUE(gb.contains(CoCoA::power(x, 2) - 1));
}

TEST_F(TestTheoryFfSplitGb, IdealMembershipSpecializations)
{
  CoCoA::ring coeffRing = CoCoA::NewZZmod(7);
  CoCoA::PolyRing polyRing =
      CoCoA::NewPolyRing(coeffRing, CoCoA::symbols("x,y"));
  CoCoA::RingElem x = CoCoA::indet(polyRing, 0);
  CoCoA::RingElem y = CoCoA::indet(polyRing, 1);
  std::vector<CoCoA::RingElem> generators{CoCoA::power(x, 2) - 1, x * y};
  std::vector<std::unique_ptr<ff::IdealMembership>> membership;
  membership.push_back(std::make_unique<ff::CocoaIdealMembership>(generators));
  membership.push_back(std::make_unique<ff::Gb>(generators, nullptr));
  membership.push_back(std::make_unique<ff::PowerDifferenceIdealMembership>(
      generators,
      nullptr,
      ff::PowerDifferenceIdealMembership::MixedIdealStrategy::COMPLETE_GB));

  for (const auto& strategy : membership)
  {
    ASSERT_TRUE(strategy->contains(y));
    ASSERT_TRUE(CoCoA::IsZero(strategy->reduce(y)));
  }
}

}  // namespace test
}  // namespace cvc5::internal
#endif  // CVC5_USE_COCOA
