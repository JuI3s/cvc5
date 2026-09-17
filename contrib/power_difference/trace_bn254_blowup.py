#!/usr/bin/env python3
###############################################################################
# This file is part of the cvc5 project.
#
# Copyright (c) 2009-2026 by the authors listed in the file AUTHORS
# in the top-level source directory and their institutional affiliations.
# All rights reserved.  See the file COPYING in the top-level source
# directory for licensing information.
# #############################################################################
"""Run and trace the naive BN254 multiplication-expansion baseline."""

import argparse
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile
import time


REPO_ROOT = Path(__file__).resolve().parents[2]
BENCHMARK = (
    REPO_ROOT
    / "contrib"
    / "power_difference"
    / "benchmarks"
    / "bn254_multiplication_expansion.smt2"
)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--binary",
        type=Path,
        default=Path("build/bin/cvc5"),
        help="cvc5 binary, relative to the repository root by default",
    )
    parser.add_argument(
        "--seconds",
        type=float,
        default=20.0,
        help="maximum solver runtime before taking a stack trace (default: 20)",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        help="artifact directory (default: a retained temporary directory)",
    )
    parser.add_argument(
        "--no-debugger",
        action="store_true",
        help="run directly instead of collecting crash backtraces with LLDB/GDB",
    )
    return parser.parse_args()


def resolve_from_root(path):
    return path if path.is_absolute() else REPO_ROOT / path


def process_tree(pid):
    """Return pid and all of its descendants with their resident sizes."""
    try:
        output = subprocess.check_output(
            ["ps", "-axo", "pid=,ppid=,rss="],
            stderr=subprocess.DEVNULL,
            text=True,
        )
        rows = [tuple(map(int, line.split())) for line in output.splitlines()]
    except (OSError, subprocess.CalledProcessError, ValueError):
        return []

    descendants = {pid}
    changed = True
    while changed:
        changed = False
        for child, parent, _ in rows:
            if parent in descendants and child not in descendants:
                descendants.add(child)
                changed = True
    return [(child, rss) for child, _, rss in rows if child in descendants]


def traced_command(binary, benchmark, no_debugger):
    """Wrap the solver in a debugger so abnormal exits include backtraces."""
    if not no_debugger and sys.platform == "darwin" and shutil.which("lldb"):
        return [
            shutil.which("lldb"),
            "--batch",
            "-o",
            "run",
            "-k",
            "thread backtrace all",
            "--",
            str(binary),
            str(benchmark),
        ], True
    if not no_debugger and shutil.which("gdb"):
        return [
            shutil.which("gdb"),
            "--batch",
            "--quiet",
            "-ex",
            "run",
            "-ex",
            "thread apply all bt",
            "--args",
            str(binary),
            str(benchmark),
        ], True
    return [str(binary), str(benchmark)], False


def capture_stack(pid):
    """Capture all thread stacks using the native debugger when available."""
    if sys.platform == "darwin" and Path("/usr/bin/sample").is_file():
        command = ["/usr/bin/sample", str(pid), "1", "1"]
    elif shutil.which("gdb"):
        command = [
            "gdb",
            "--batch",
            "--quiet",
            "-ex",
            "thread apply all bt",
            "-p",
            str(pid),
        ]
    else:
        stack = Path("/proc") / str(pid) / "stack"
        try:
            return stack.read_text(encoding="utf-8")
        except OSError as err:
            return f"No supported stack sampler: {err}\n"

    try:
        completed = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=15,
            check=False,
        )
        return completed.stdout
    except (OSError, subprocess.TimeoutExpired) as err:
        return f"Stack sampling failed: {err}\n"


def tail_text(path, limit=80_000):
    with path.open("rb") as stream:
        stream.seek(0, os.SEEK_END)
        size = stream.tell()
        stream.seek(max(0, size - limit))
        return stream.read().decode("utf-8", errors="replace")


def recent_stack(stack):
    """Select the call-graph portion of a macOS sample or recent GDB frames."""
    lines = stack.splitlines()
    try:
        start = next(i for i, line in enumerate(lines) if "Call graph:" in line)
    except StopIteration:
        return "\n".join(lines[-160:])

    end = len(lines)
    for i in range(start + 1, len(lines)):
        if lines[i].startswith(("Total number in stack", "Binary Images:")):
            end = i
            break
    return "\n".join(lines[start:min(end, start + 160)])


def main():
    args = parse_args()
    binary = resolve_from_root(args.binary)
    if not binary.is_file():
        print(f"error: cvc5 binary not found: {binary}", file=sys.stderr)
        return 2
    if args.seconds <= 0:
        print("error: --seconds must be positive", file=sys.stderr)
        return 2

    if args.output_dir:
        output_dir = resolve_from_root(args.output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
    else:
        output_dir = Path(tempfile.mkdtemp(prefix="cvc5-bn254-blowup-"))
    stdout_path = output_dir / "stdout.txt"
    stderr_path = output_dir / "stderr.txt"
    stack_path = output_dir / "stack.txt"

    command, using_debugger = traced_command(
        binary, BENCHMARK, args.no_debugger
    )
    print("+", " ".join(command), flush=True)
    print(f"solver cutoff: {args.seconds:g} seconds", flush=True)
    start = time.monotonic()
    peak_kib = 0
    with stdout_path.open("wb") as stdout, stderr_path.open("wb") as stderr:
        process = subprocess.Popen(
            command,
            cwd=REPO_ROOT,
            stdout=stdout,
            stderr=stderr,
            start_new_session=True,
        )
        while process.poll() is None:
            elapsed = time.monotonic() - start
            if elapsed >= args.seconds:
                break
            tree = process_tree(process.pid)
            peak_kib = max(peak_kib, sum(rss for _, rss in tree))
            time.sleep(min(0.25, args.seconds - elapsed))

        timed_out = process.poll() is None
        if timed_out:
            # Freeze at the cutoff so the trace reflects the last solver call
            # without allowing additional expansion while it is collected.
            os.killpg(process.pid, signal.SIGSTOP)
            tree = process_tree(process.pid)
            target_pid = tree[-1][0] if tree else process.pid
            stack_path.write_text(capture_stack(target_pid), encoding="utf-8")
            os.killpg(process.pid, signal.SIGKILL)
        else:
            if using_debugger:
                stdout.flush()
                stderr.flush()
                stack_path.write_text(
                    tail_text(stdout_path) + tail_text(stderr_path),
                    encoding="utf-8",
                )
            else:
                stack_path.write_text(
                    "The solver exited before the cutoff; run without "
                    "--no-debugger to capture an abnormal-exit backtrace.\n",
                    encoding="utf-8",
                )
        process.wait()

    elapsed = time.monotonic() - start
    print("\nresult")
    print(f"  reached cutoff: {timed_out}")
    print(f"  runner return code: {process.returncode}")
    print(f"  elapsed including trace collection: {elapsed:.3f} s")
    print(f"  peak resident memory: {peak_kib} KiB ({peak_kib / 1048576:.3f} GiB)")

    print("\nstdout")
    print(tail_text(stdout_path) or "<empty>")
    print("\nstderr")
    print(tail_text(stderr_path) or "<empty>")
    print("\nlatest sampled calls")
    print(recent_stack(stack_path.read_text(encoding="utf-8")) or "<empty>")
    print(f"\nfull artifacts: {output_dir}")

    combined = tail_text(stdout_path) + tail_text(stderr_path)
    crashed = process.returncode != 0 or "stop reason = signal" in combined
    crashed = crashed or "Fatal failure" in combined
    # Timeout or abnormal exit demonstrates the baseline failure. A normal
    # completion is unexpected and should make an automated run fail.
    return 0 if timed_out or crashed else 1


if __name__ == "__main__":
    sys.exit(main())
