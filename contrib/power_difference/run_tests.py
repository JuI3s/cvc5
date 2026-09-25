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
    r"^regress0/ff/(ideal_membership_command|"
    r"ideal_membership_definitions|ideal_membership_mixed_unknown|"
    r"ideal_membership_neg|"
    r"ntt_negacyclic_n4|"
    r"power_difference_bn254|prime_subfield_f49|"
    r"torus_e2e_bn254|torus_e2e_bn254_original_tower)\.smt2$"
)
BENCHMARK = (
    REPO_ROOT
    / "contrib"
    / "power_difference"
    / "benchmarks"
    / "bn254_multiplication_expansion.smt2"
)
TORUS_GENERATOR = (
    REPO_ROOT / "contrib" / "power_difference" / "generate_torus_e2e.py"
)
NTT_GENERATOR = REPO_ROOT / "contrib" / "power_difference" / "generate_ntt_e2e.py"


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


def unit_environment(build_dir, test_filter=POWER_DIFFERENCE_FILTER):
    """Return an environment that can load CMake's selected GoogleTest."""
    env = os.environ.copy()
    env["GTEST_FILTER"] = test_filter

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
        help="also run compact-power, NTT, F_49, and torus regression tests",
    )
    parser.add_argument(
        "--benchmark",
        action="store_true",
        help="run the intentionally infeasible BN254 multiplication benchmark",
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
            build(build_dir, "cvc5-bin")

    # GTest's environment filter keeps this invocation focused on the
    # prototype while still running the test through cvc5's CTest entry.
    ctest(build_dir, UNIT_TEST, env=unit_environment(build_dir), verbose=True)

    if args.regressions:
        run([sys.executable, TORUS_GENERATOR, "--check"])
        run([sys.executable, NTT_GENERATOR, "--check"])
        ctest(build_dir, REGRESSION_TESTS)
    if args.benchmark:
        # This is deliberately not a regression: current cvc5 expands the
        # final power to q^2 factors and is not expected to finish.
        run([build_dir / "bin" / "cvc5", BENCHMARK])
    return 0


if __name__ == "__main__":
    sys.exit(main())
