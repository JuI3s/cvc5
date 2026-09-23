#!/usr/bin/env python3
###############################################################################
# This file is part of the cvc5 project.
#
# Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
# in the top-level source directory and their institutional affiliations.
# All rights reserved.  See the file COPYING in the top-level source
# directory for licensing information.
# #############################################################################
"""Render the symbolic size-4 NTT regression from its SMT template."""

import argparse
import difflib
import json
from pathlib import Path
from string import Template
import sys


REPO_ROOT = Path(__file__).resolve().parents[2]
SOURCE_DIR = REPO_ROOT / "contrib" / "power_difference"
OUTPUT_DIR = REPO_ROOT / "test" / "regress" / "cli" / "regress0" / "ff"
TEMPLATE_PATH = SOURCE_DIR / "ntt_e2e_n4.smt2.in"
CONFIG_PATH = SOURCE_DIR / "ntt_e2e_n4.json"


def read_inputs():
    """Load the literal SMT template and its substitution record."""
    template = Template(TEMPLATE_PATH.read_text(encoding="utf-8"))
    data = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    return template, data


def render(template, data):
    """Validate the size-4 parameters and render the SMT regression."""
    modulus = int(data["modulus"])
    size = int(data["transform_size"])
    size_inverse = int(data["transform_size_inverse"])
    if size != 4:
        raise ValueError("ntt_e2e_n4.smt2.in is the literal size-4 transform")
    if size * size_inverse % modulus != 1:
        raise ValueError("transform_size_inverse is not the modular inverse")
    expected_check_count = sum(check["coordinates"] for check in data["checks"])
    if any(check["coordinates"] != size for check in data["checks"]):
        raise ValueError("each identity must have one check per NTT coordinate")
    values = dict(data)
    check_count = template.template.count("\n(check-sat)")
    if check_count != expected_check_count:
        raise ValueError("check metadata does not match the SMT template")
    values["expectations"] = "\n".join(
        f"; EXPECT: {data['expected']}" for _ in range(check_count)
    )
    return template.substitute(values)


def check_output(path, expected):
    """Report whether the generated regression differs from its inputs."""
    actual = path.read_text(encoding="utf-8") if path.is_file() else ""
    if actual == expected:
        return True
    sys.stderr.writelines(
        difflib.unified_diff(
            actual.splitlines(keepends=True),
            expected.splitlines(keepends=True),
            fromfile=str(path),
            tofile=f"{path} (generated)",
        )
    )
    return False


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail if the checked-in SMT file differs from the template",
    )
    args = parser.parse_args()

    template, data = read_inputs()
    path = OUTPUT_DIR / data["filename"]
    output = render(template, data)
    if args.check:
        return 0 if check_output(path, output) else 1
    path.write_text(output, encoding="utf-8")
    print(path.relative_to(REPO_ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())
