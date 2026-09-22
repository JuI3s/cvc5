#!/usr/bin/env python3
###############################################################################
# This file is part of the cvc5 project.
#
# Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
# in the top-level source directory and their institutional affiliations.
# All rights reserved.  See the file COPYING in the top-level source
# directory for licensing information.
# #############################################################################
"""Render BN254 torus regressions from an SMT template and JSON data."""

import argparse
import difflib
import json
from pathlib import Path
from string import Template
import sys
import textwrap


REPO_ROOT = Path(__file__).resolve().parents[2]
SOURCE_DIR = REPO_ROOT / "contrib" / "power_difference"
OUTPUT_DIR = REPO_ROOT / "test" / "regress" / "cli" / "regress0" / "ff"
TEMPLATE_PATH = SOURCE_DIR / "torus_e2e_bn254.smt2.in"
CONFIG_PATH = SOURCE_DIR / "torus_e2e_bn254.json"


def read_inputs():
    """Load the literal SMT template and its substitution records."""
    template = Template(TEMPLATE_PATH.read_text(encoding="utf-8"))
    data = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    return template, data["shared"], data["towers"]


def render(template, shared, tower):
    """Render one tower after formatting its comment and multiline term."""
    values = dict(shared)
    values.update(tower)
    values["description"] = "\n".join(f"; {line}" for line in tower["description"])
    values["sigma_q2_rhs"] = textwrap.indent(
        "\n".join(tower["sigma_q2_rhs"]), "    "
    )
    return template.substitute(values)


def check_output(path, expected):
    """Report whether a generated file differs from the template."""
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
        help="fail if checked-in SMT files differ from the template",
    )
    args = parser.parse_args()

    template, shared, towers = read_inputs()
    valid = True
    for tower in towers:
        path = OUTPUT_DIR / tower["filename"]
        output = render(template, shared, tower)
        if args.check:
            valid = check_output(path, output) and valid
        else:
            path.write_text(output, encoding="utf-8")
            print(path.relative_to(REPO_ROOT))
    return 0 if valid else 1


if __name__ == "__main__":
    sys.exit(main())
