#!/usr/bin/env python3
"""Shared SBPF micro-validation orchestration.

This script owns the language-independent instruction-level path:
  1. ensure the BigInt profile is available at Stage 1 and Stage 2,
  2. generate random step-test vectors unless an existing data file is supplied,
  3. run the OCaml, Stage-1 Rust, and Stage-2 Rust step runners,
  4. print one combined statistical summary.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

from sbpf_exports import ensure_two_stage_exports


@dataclass
class StageResult:
    name: str
    passed: int | None
    failed: int | None
    rc: int
    note: str = ""

    @property
    def total(self) -> int | None:
        if self.passed is None or self.failed is None:
            return None
        return self.passed + self.failed


ROOT = Path(__file__).resolve().parents[4]
EXEC_DIR = ROOT / "test" / "sbpf" / "tests" / "exec_semantics"
DATA_DIR = ROOT / "test" / "sbpf" / "tests" / "data"
BASELINE_THEORY = "bpf_generator_bigint"
THEORY = os.environ.get("SBPF_THEORY") or "bpf_generator_bigint"
STAGE1_EXPORT_DIR = Path(
    os.environ.get("SBPF_EXPORT_DIR")
    or ROOT / "test" / "sbpf" / "theory" / "stage1" / THEORY
)
if not STAGE1_EXPORT_DIR.is_absolute():
    STAGE1_EXPORT_DIR = ROOT / STAGE1_EXPORT_DIR
STAGE2_EXPORT_DIR = Path(
    os.environ.get("SBPF_STAGE2_EXPORT_DIR")
    or ROOT / "test" / "sbpf" / "theory" / "stage2" / THEORY
)
if not STAGE2_EXPORT_DIR.is_absolute():
    STAGE2_EXPORT_DIR = ROOT / STAGE2_EXPORT_DIR
OCAML_EXPORT_DIR = ROOT / "test" / "sbpf" / "theory" / "stage1" / BASELINE_THEORY
STEP_JSON = Path(os.environ.get("SBPF_STEP_JSON") or DATA_DIR / "ocaml_in.json")
if not STEP_JSON.is_absolute():
    STEP_JSON = ROOT / STEP_JSON
GENERATOR_DIR = ROOT / "test" / "sbpf" / "tests" / "rbpf" / "step_test_random"

OCAML_RUNNER = EXEC_DIR / "sbpf_ocaml" / "run_step_micro.py"
RUST_RUNNER = EXEC_DIR / "sbpf_rust" / "run_step_micro.py"

PASSED_RE = re.compile(r"Passed:\s*(\d+)")
FAILED_RE = re.compile(r"Failed:\s*(\d+)")
FAILED_NOTE_RE = re.compile(r"Failed:\s*\d+\s*\(of which ([^)]+)\)")


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def announce(title: str, detail: str) -> None:
    print(f">>> [micro_sbpf] {title}: {detail}", flush=True)


def run_command(
    cmd: list[str],
    *,
    cwd: Path,
    env: dict[str, str] | None = None,
) -> tuple[int, str]:
    proc = subprocess.Popen(
        cmd,
        cwd=str(cwd),
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )
    output: list[str] = []
    assert proc.stdout is not None
    for line in proc.stdout:
        output.append(line)
        print(line, end="")
    rc = proc.wait()
    return rc, "".join(output)


def parse_summary(name: str, rc: int, output: str, note: str = "") -> StageResult:
    passed_match = PASSED_RE.findall(output)
    failed_match = FAILED_RE.findall(output)
    if not passed_match or not failed_match:
        return StageResult(name, None, None, rc, note or "no summary found")
    failed_note = FAILED_NOTE_RE.findall(output)
    if failed_note and not note:
        note = failed_note[-1]
    return StageResult(name, int(passed_match[-1]), int(failed_match[-1]), rc, note)


def generate_step_json() -> int:
    count = os.environ.get("X") or os.environ.get("num") or "10000"
    seed = os.environ.get("SBPF_STEP_SEED") or "5984326"
    announce(
        "generator",
        f"generating {count} random step cases with seed {seed} into {rel(STEP_JSON)}",
    )
    rust_toolchain = os.environ.get("RUST_TOOLCHAIN") or "1.94.0"
    env = os.environ.copy()
    env.pop("RUSTC_BOOTSTRAP", None)
    rc, _ = run_command(
        ["cargo", f"+{rust_toolchain}", "run", "--locked", "--", count, str(STEP_JSON), seed],
        cwd=GENERATOR_DIR,
        env=env,
    )
    return rc


def run_stage(
    name: str,
    script: Path,
    export_dir: Path,
    *,
    rust_stage: int | None = None,
) -> StageResult:
    env = os.environ.copy()
    env.pop("RUSTC_BOOTSTRAP", None)
    env["SBPF_ROOT"] = str(ROOT)
    env["SBPF_EXEC_DIR"] = str(EXEC_DIR)
    env["SBPF_DATA_DIR"] = str(DATA_DIR)
    env["SBPF_EXPORT_DIR"] = str(export_dir)
    env["SBPF_STEP_JSON"] = str(STEP_JSON)
    if rust_stage is not None:
        env["SBPF_STAGE"] = str(rust_stage)

    announce(name, f"running {rel(script)}")
    rc, output = run_command(["python3", str(script)], cwd=ROOT, env=env)
    return parse_summary(name, rc, output)


def print_final_summary(results: list[StageResult]) -> None:
    print("\n========================================")
    print("micro_sbpf summary")
    for result in results:
        if result.total is None:
            detail = f"no summary (exit {result.rc})"
            if result.note:
                detail += f", {result.note}"
            print(f"  {result.name}: {detail}")
        else:
            detail = (
                f"  {result.name}: Passed {result.passed} / "
                f"Failed {result.failed} / Total {result.total}"
            )
            if result.note:
                detail += f" ({result.note})"
            print(detail)

    failed_cases = sum(result.failed or 0 for result in results)
    infra_failed = any(result.total is None or result.rc not in (0, 1) for result in results)
    print("  Overall: PASS" if failed_cases == 0 and not infra_failed else "  Overall: FAIL")


def run_micro() -> int:
    if not ensure_two_stage_exports(
        root=ROOT,
        theory=THEORY,
        baseline_theory=BASELINE_THEORY,
        stage1_dir=STAGE1_EXPORT_DIR,
        stage2_dir=STAGE2_EXPORT_DIR,
        ocaml_dir=OCAML_EXPORT_DIR,
        force_rebuild=os.environ.get("REBUILD") == "1",
        announce=announce,
        run_command=run_command,
    ):
        print_final_summary([StageResult("two-stage export", None, None, 1, "generation failed")])
        return 1

    supplied_data = bool(os.environ.get("SBPF_STEP_JSON"))
    requested_count = bool(os.environ.get("X") or os.environ.get("num"))
    if not supplied_data or requested_count:
        if generate_step_json() != 0:
            print_final_summary([StageResult("test data", None, None, 1, "generation failed")])
            return 1

    if not STEP_JSON.exists():
        print_final_summary([StageResult("shared data", None, None, 1, f"missing {rel(STEP_JSON)}")])
        return 1

    results = [
        run_stage("OCaml export", OCAML_RUNNER, OCAML_EXPORT_DIR),
        run_stage("Stage-1 Rust export", RUST_RUNNER, STAGE1_EXPORT_DIR, rust_stage=1),
        run_stage("Stage-2 Rust export", RUST_RUNNER, STAGE2_EXPORT_DIR, rust_stage=2),
    ]
    print_final_summary(results)

    for result in results:
        if result.total is None:
            return 1
        if result.failed:
            return 1
        if result.rc not in (0, 1):
            return result.rc
    return 0


def main() -> int:
    if len(sys.argv) > 1 and sys.argv[1] == "gen":
        return generate_step_json()
    return run_micro()


if __name__ == "__main__":
    sys.exit(main())
