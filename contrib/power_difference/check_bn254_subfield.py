#!/usr/bin/env python3
###############################################################################
# This file is part of the cvc5 project.
#
# Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
# in the top-level source directory and their institutional affiliations.
# All rights reserved.  See the file COPYING in the top-level source
# directory for licensing information.
# #############################################################################
"""Check one direct BN254 power-difference ideal-membership query."""

import argparse
from pathlib import Path
import sys

from run_tests import build, ctest, unit_environment


REPO_ROOT = Path(__file__).resolve().parents[2]
UNIT_TARGET = "theory_ff_split_gb_black"
UNIT_TEST = r"^unit/theory/theory_ff_split_gb_black$"
BN254_FILTER = "TestTheoryFfSplitGb.PowerDifferenceBn254SubfieldMembership"


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
        help="use the existing unit-test binary without rebuilding it",
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

    # This exact test constructs <x^q - x> and calls contains(x^(q^2) - x).
    # It does not pass through SMT disequality encoding or root finding.
    env = unit_environment(build_dir, BN254_FILTER)
    ctest(build_dir, UNIT_TEST, env=env, verbose=True)
    print("PASS: x^(q^2) - x is in <x^q - x> for the BN254 base prime")
    return 0


if __name__ == "__main__":
    sys.exit(main())
