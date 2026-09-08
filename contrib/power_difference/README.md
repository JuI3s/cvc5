# Power-Difference Ideal Membership Prototype

This directory contains the convenience runner for the power-difference ideal
membership research prototype. The implementation and its tests remain in the
standard cvc5 source and test directories so that cvc5's normal build and CI
infrastructure exercise them.

Configure a testing build with CoCoA once:

```sh
./configure.sh testing --gpl --cocoa --auto-download --name=build
```

Then build and run all power-difference unit tests:

```sh
contrib/power_difference/run_tests.py
```

Use `--build-dir NAME` for another configured build directory. The runner uses
the registered CTest test and applies a GoogleTest filter to the
power-difference cases. If CMake selected shared GoogleTest libraries, the
runner obtains their runtime path from `CMakeCache.txt`.

The two optional groups serve different purposes:

```sh
contrib/power_difference/run_tests.py --regressions
contrib/power_difference/run_tests.py --benchmark
```

`--regressions` also checks the unsupported compact `ff.pow` syntax and the
explicit `F_7` subfield of `F_49`. `--benchmark` runs the slow Kyber-prime
naive-multiplication reproducer. The benchmark exercises unmodified cvc5 input
processing, not `PowerDifferenceIdealMembership`, and intentionally sets no
benchmark-specific time or resource limit.
