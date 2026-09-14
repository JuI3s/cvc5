# Power-Difference Ideal Membership Prototype

This directory contains the convenience runner for the power-difference ideal
membership research prototype. The implementation and its tests remain in the
standard cvc5 source and test directories so that cvc5's normal build and CI
infrastructure exercise them.

The prototype adds the indexed term `((_ ff.pow n) t)` for compact
finite-field powers. This syntax is a cvc5 research extension, not a standard
SMT-LIB finite-field operator.

Configure a testing build with CoCoA once:

```sh
./configure.sh testing --gpl --cocoa --auto-download --name=build
```

Then build and run all power-difference unit tests:

```sh
contrib/power_difference/run_tests.py
```

To check the single direct BN254 ideal-membership query
`x^(q^2) - x in <x^q - x>`:

```sh
contrib/power_difference/check_bn254_subfield.py --build-dir build
```

Pass `--no-build` to reuse the existing unit-test binary. This invokes
`PowerDifferenceIdealMembership::contains()` directly: it does not introduce
a witness variable, construct a combined ideal, translate an SMT disequality,
or perform root finding.

Use `--build-dir NAME` for another configured build directory. The runner uses
the registered CTest test and applies a GoogleTest filter to the
power-difference cases. If CMake selected shared GoogleTest libraries, the
runner obtains their runtime path from `CMakeCache.txt`.

The two optional groups serve different purposes:

```sh
contrib/power_difference/run_tests.py --regressions
contrib/power_difference/run_tests.py --benchmark
```

`--regressions` also checks the BN254 Frobenius implication through compact
`ff.pow` terms and the explicit `F_7` subfield of `F_49`. `--benchmark` runs
the intentionally infeasible BN254 naive-multiplication reproducer. The
benchmark exercises multiplication expansion instead of
`PowerDifferenceIdealMembership` and intentionally sets no benchmark-specific
time or resource limit. It is kept outside the regression suite because a
successful completion is not expected with current cvc5.

In one local run, the benchmark aborted in `NodeBuilder::realloc()` after
46.495 seconds at 0.996 GiB peak resident memory, before solving began.
