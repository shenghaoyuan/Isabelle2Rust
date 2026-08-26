#!/usr/bin/env python3
"""Count normalized Stage-1 and Stage-2 generated Rust LOC for RQ2."""

from __future__ import annotations

import argparse
import csv
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path


REPO = Path(__file__).resolve().parents[3]
CRATES = {
    "SBPF-program": {
        "stage1": "test/sbpf/theory/stage1/bpf_generator_bigint/interp_test",
        "stage2": "test/sbpf/theory/stage2/bpf_generator_bigint/interp_test",
    },
    "SBPF-instruction": {
        "stage1": "test/sbpf/theory/stage1/bpf_generator_bigint/step_test",
        "stage2": "test/sbpf/theory/stage2/bpf_generator_bigint/step_test",
    },
    "X64-stepper": {
        "stage1": "test/x64/theory/stage1/x64_generator_bigint/x64_step_test",
        "stage2": "test/x64/theory/stage2/x64_generator_bigint/x64_step_test",
    },
}
RUST_TEST = re.compile(
    r"#\s*!?\s*\[\s*(?:test|cfg\s*\(\s*test\s*\))\s*\]",
    re.MULTILINE,
)


def cloc(root: Path) -> tuple[int, int]:
    if not (root / "Cargo.toml").is_file():
        raise RuntimeError(f"missing generated crate: {root.relative_to(REPO)}")
    # Validation workflows install their handwritten executable as
    # ``src/main.rs``. Count only the generated library modules, irrespective
    # of whether that harness is currently present in the working crate.
    sources = sorted(
        source for source in (root / "src").rglob("*.rs") if source.name != "main.rs"
    )
    if not sources:
        raise RuntimeError(f"no generated Rust sources under {(root / 'src').relative_to(REPO)}")
    for source in sources:
        if RUST_TEST.search(source.read_text(encoding="utf-8", errors="replace")):
            raise RuntimeError(f"Rust test item present in generated source: {source.relative_to(REPO)}")

    with tempfile.TemporaryDirectory(prefix="isabelle2rust-loc-") as temporary:
        temporary_root = Path(temporary)
        formatted_sources = []
        for source in sources:
            target = temporary_root / source.relative_to(root)
            target.parent.mkdir(parents=True, exist_ok=True)
            text = source.read_text(encoding="utf-8")
            normalized = "\n".join(line.rstrip() for line in text.splitlines())
            if text.endswith(("\n", "\r")):
                normalized += "\n"
            target.write_text(normalized, encoding="utf-8")
            formatted_sources.append(target)

        try:
            formatted = subprocess.run(
                [
                    "rustfmt", "--edition", "2021", "--config", "skip_children=true",
                    *map(str, formatted_sources),
                ],
                cwd=REPO, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            )
        except FileNotFoundError as error:
            raise RuntimeError("rustfmt not found; install the pinned rustfmt component") from error
        if formatted.returncode != 0:
            raise RuntimeError(formatted.stderr.strip())

        result = subprocess.run(
            [
                "cloc", "--json", "--quiet", "--skip-uniqueness", "--include-lang=Rust",
                *map(str, formatted_sources),
            ],
            cwd=REPO, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        )
        if result.returncode != 0:
            raise RuntimeError(result.stderr.strip())
        rust = json.loads(result.stdout).get("Rust", {})
        return int(rust.get("nFiles", 0)), int(rust.get("code", 0))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__); parser.add_argument("--output", type=Path); args = parser.parse_args()
    rows = []
    for workload, stages in CRATES.items():
        for stage, relative in stages.items():
            files, loc = cloc(REPO / relative)
            rows.append({"workload": workload, "stage": stage, "rust_files": files, "rust_loc": loc})
    target = args.output.open("w", newline="", encoding="utf-8") if args.output else sys.stdout
    try:
        writer = csv.DictWriter(target, fieldnames=list(rows[0]), lineterminator="\n"); writer.writeheader(); writer.writerows(rows)
    finally:
        if args.output: target.close()
    return 0


if __name__ == "__main__":
    try: sys.exit(main())
    except RuntimeError as error: print(f"ERROR: {error}", file=sys.stderr); sys.exit(1)
