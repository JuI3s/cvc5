#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
cvc5_binary="${1:-$repo_root/build/bin/cvc5}"
test_dir="$repo_root/test/regress/cli/regress0/ff"

if [[ ! -x "$cvc5_binary" ]]; then
  echo "error: cvc5 binary is not executable: $cvc5_binary" >&2
  echo "usage: $0 [path/to/cvc5]" >&2
  exit 2
fi

run_case()
{
  local filename="$1"
  local expected="$2"
  local actual

  echo "=== $filename ==="
  actual="$("$cvc5_binary" "$test_dir/$filename")"
  echo "result:   $actual"
  echo "expected: $expected"

  if [[ "$actual" != "$expected" ]]; then
    echo "FAILED" >&2
    return 1
  fi

  echo "PASSED"
  echo
}

# The corrected tower makes the target polynomial an ideal member.
run_case torus_e2e_bn254.smt2 sat

# The original tower does not satisfy the same target identity.
run_case torus_e2e_bn254_original_tower.smt2 unsat
