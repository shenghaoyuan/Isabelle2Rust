#!/usr/bin/env python3
"""Run the complete x64 validation and print one combined summary."""

from __future__ import annotations

import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]

ANSI_ESCAPE_RE = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")
OCAML_SUMMARY_RE = re.compile(r"Summary:\s*(\d+) passed\s*/\s*(\d+) failed")
RUST_SUMMARY_RE = re.compile(
    r"Rust semantics vs CPU:\s*(\d+) passed\s*/\s*(\d+) failed"
    r"\s*\((\d+) panicked\)"
)


@dataclass(frozen=True)
class StageResult:
    name: str
    passed: int | None
    failed: int | None
    note: str = ""

    @property
    def total(self) -> int | None:
        if self.passed is None or self.failed is None:
            return None
        return self.passed + self.failed


def run_validation() -> tuple[int, str]:
    """Run existing Make targets while retaining their output for parsing."""

    command = [
        os.environ.get("MAKE", "make"),
        "--no-print-directory",
        "x64-gen",
        "x64-test",
        "x64-stage2-test",
    ]
    process = subprocess.Popen(
        command,
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )
    output: list[str] = []
    assert process.stdout is not None
    for line in process.stdout:
        output.append(line)
        print(line, end="")
    return process.wait(), "".join(output)


def parse_results(output: str) -> list[StageResult]:
    output = ANSI_ESCAPE_RE.sub("", output)
    ocaml_matches = OCAML_SUMMARY_RE.findall(output)
    rust_matches = RUST_SUMMARY_RE.findall(output)

    results = [
        StageResult(
            "OCaml export",
            int(ocaml_matches[-1][0]) if ocaml_matches else None,
            int(ocaml_matches[-1][1]) if ocaml_matches else None,
            "" if ocaml_matches else "not completed",
        )
    ]
    for index, name in enumerate(("Stage-1 Rust export", "Stage-2 Rust export")):
        if index < len(rust_matches):
            passed, failed, panicked = rust_matches[index]
            results.append(
                StageResult(name, int(passed), int(failed), f"{panicked} panicked")
            )
        else:
            results.append(StageResult(name, None, None, "not completed"))
    return results


def print_final_summary(results: list[StageResult], returncode: int) -> None:
    print("\n========================================")
    print("x64 summary")
    for result in results:
        if result.total is None:
            print(f"  {result.name}: no summary ({result.note})")
            continue
        detail = (
            f"  {result.name}: Passed {result.passed} / "
            f"Failed {result.failed} / Total {result.total}"
        )
        if result.note:
            detail += f" ({result.note})"
        print(detail)

    passed = returncode == 0 and all(
        result.total is not None and result.failed == 0 for result in results
    )
    print("  Overall: PASS" if passed else "  Overall: FAIL")


def main() -> int:
    returncode, output = run_validation()
    results = parse_results(output)
    print_final_summary(results, returncode)
    if returncode != 0:
        return returncode
    return 0 if all(result.total is not None and result.failed == 0 for result in results) else 1


if __name__ == "__main__":
    sys.exit(main())
