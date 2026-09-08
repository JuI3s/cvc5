#!/usr/bin/env python3
###############################################################################
# This file is part of the cvc5 project.
#
# Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
# in the top-level source directory and their institutional affiliations.
# All rights reserved.  See the file COPYING in the top-level source
# directory for licensing information.
# #############################################################################
"""Build and run the power-difference prototype tests."""

import argparse
import os
from pathlib import Path
import subprocess
import sys


REPO_ROOT = Path(__file__).resolve().parents[2]
UNIT_TARGET = "theory_ff_split_gb_black"
UNIT_TEST = r"^unit/theory/theory_ff_split_gb_black$"
POWER_DIFFERENCE_FILTER = "TestTheoryFfSplitGb.PowerDifference*"
REGRESSION_TESTS = (
    r"^regress0/ff/(power_operator_unsupported|prime_subfield_f49)\.smt2$"
)
BENCHMARK_TEST = r"^regress3/ff/power_multiplication_expansion\.smt2$"


def run(command, *, env=None):
    """Run a command from the repository root and fail on an error."""
    print("+", " ".join(map(str, command)), flush=True)
    subprocess.run(command, cwd=REPO_ROOT, env=env, check=True)


def build(build_dir, target):
    """Build one configured cvc5 CMake target."""
    run(["cmake", "--build", str(build_dir), "--target", target])


def ctest(build_dir, pattern, *, env=None, verbose=False):
    """Run exactly the CTest entries matching pattern."""
    command = [
        "ctest",
        "--test-dir",
        str(build_dir),
        "--output-on-failure",
    ]
    if verbose:
        command.append("--verbose")
    command.extend(["-R", pattern])
    run(command, env=env)


def unit_environment(build_dir):
    """Return an environment that can load CMake's selected GoogleTest."""
    env = os.environ.copy()
    env["GTEST_FILTER"] = POWER_DIFFERENCE_FILTER

    cache = build_dir / "CMakeCache.txt"
    library_dirs = []
    for line in cache.read_text(encoding="utf-8").splitlines():
        if line.startswith(("GTest_LIBRARIES:", "GTest_MAIN_LIBRARIES:")):
            path = Path(line.partition("=")[2])
            if path.is_absolute() and path.parent not in library_dirs:
                library_dirs.append(path.parent)

    if library_dirs:
        if sys.platform == "darwin":
            variable = "DYLD_LIBRARY_PATH"
        elif os.name == "nt":
            variable = "PATH"
        else:
            variable = "LD_LIBRARY_PATH"
        previous = env.get(variable)
        paths = [str(path) for path in library_dirs]
        if previous:
            paths.append(previous)
        env[variable] = os.pathsep.join(paths)
    return env


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--build-dir",
        type=Path,
        default=Path("build"),
        help="configured CMake build directory (default: build)",
    )
    parser.add_argument(
        "--no-build",
        action="store_true",
        help="run existing test binaries without rebuilding them",
    )
    parser.add_argument(
        "--regressions",
        action="store_true",
        help="also run the compact-power and F_49 regression tests",
    )
    parser.add_argument(
        "--benchmark",
        action="store_true",
        help="also run the slow Kyber-prime multiplication benchmark",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    build_dir = args.build_dir
    if not build_dir.is_absolute():
        build_dir = REPO_ROOT / build_dir
    if not (build_dir / "CMakeCache.txt").is_file():
        print(
            f"error: {build_dir} is not a configured CMake build directory",
            file=sys.stderr,
        )
        return 2

    if not args.no_build:
        build(build_dir, UNIT_TARGET)
        if args.regressions or args.benchmark:
            build(build_dir, "cvc5")

    # GTest's environment filter keeps this invocation focused on the
    # prototype while still running the test through cvc5's CTest entry.
    ctest(build_dir, UNIT_TEST, env=unit_environment(build_dir), verbose=True)

    if args.regressions:
        ctest(build_dir, REGRESSION_TESTS)
    if args.benchmark:
        ctest(build_dir, BENCHMARK_TEST)
    return 0


if __name__ == "__main__":
    sys.exit(main())
