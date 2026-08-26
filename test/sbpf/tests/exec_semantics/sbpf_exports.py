#!/usr/bin/env python3
"""Build and cache the two Rust stages used by the SBPF tests."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
from typing import Callable


Announce = Callable[[str, str], None]
RunCommand = Callable[..., tuple[int, str]]


def _files_under(directory: Path, suffixes: set[str]) -> list[Path]:
    if not directory.is_dir():
        return []
    return sorted(
        path
        for path in directory.rglob("*")
        if path.is_file() and path.suffix in suffixes
    )


def _fingerprint(root: Path, files: list[Path], values: dict[str, str]) -> str:
    digest = hashlib.sha256()
    for name, value in sorted(values.items()):
        digest.update(f"value:{name}\0{value}\0".encode())
    for path in sorted(set(files)):
        try:
            name = path.relative_to(root)
        except ValueError:
            name = path
        digest.update(f"file:{name}\0".encode())
        if not path.is_file():
            digest.update(b"missing\0")
            continue
        with path.open("rb") as source:
            for chunk in iter(lambda: source.read(1024 * 1024), b""):
                digest.update(chunk)
        digest.update(b"\0")
    return digest.hexdigest()


def _stage1_fingerprint(root: Path, rust_toolchain: str) -> str:
    files = _files_under(root / "translate", {".ML", ".thy"})
    files += _files_under(root / "test" / "sbpf" / "theory", {".thy"})
    files += [
        root / "ROOT",
        root / "rust-toolchain.toml",
        root / "scripts" / "ensure-cargo-lock.py",
        root / "scripts" / "isabelle-exported.Cargo.lock",
    ]
    return _fingerprint(root, files, {"rust_toolchain": rust_toolchain})


def _stage2_fingerprint(root: Path, stage1_fingerprint: str) -> str:
    rustlight = root.parent / "RustLightAST"
    files = _files_under(root / "optimize" / "src", {".rs"})
    files += [root / "optimize" / "Cargo.toml", root / "optimize" / "Cargo.lock"]
    files += _files_under(rustlight / "src", {".rs"})
    files += [rustlight / "Cargo.toml", rustlight / "Cargo.lock"]
    return _fingerprint(root, files, {"stage1": stage1_fingerprint})


def _read_state(path: Path) -> dict[str, str]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return {}
    return value if isinstance(value, dict) else {}


def _write_state(path: Path, state: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(".tmp")
    temporary.write_text(
        json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    os.replace(temporary, path)


def ensure_two_stage_exports(
    *,
    root: Path,
    theory: str,
    baseline_theory: str,
    stage1_dir: Path,
    stage2_dir: Path,
    ocaml_dir: Path,
    force_rebuild: bool,
    announce: Announce,
    run_command: RunCommand,
) -> bool:
    """Generate stale or missing SBPF exports and otherwise reuse them."""

    build_dir = root / "test" / "sbpf" / "tests" / "exec_semantics" / "_build"
    safe_theory = "".join(c if c.isalnum() or c in "-_" else "_" for c in theory)
    state_path = build_dir / f"export-cache-{safe_theory}.json"
    state = _read_state(state_path)

    stage1_outputs = [
        stage1_dir / "interp_test" / "Cargo.toml",
        stage1_dir / "step_test" / "Cargo.toml",
    ]
    stage2_outputs = [
        stage2_dir / "interp_test" / "Cargo.toml",
        stage2_dir / "step_test" / "Cargo.toml",
    ]
    ocaml_outputs = [ocaml_dir / "interp_test.ocaml", ocaml_dir / "step_test.ocaml"]

    rust_toolchain = os.environ.get("RUST_TOOLCHAIN") or "1.94.0"
    stage1_key = _stage1_fingerprint(root, rust_toolchain)
    stage2_key = _stage2_fingerprint(root, stage1_key)
    need_stage1 = (
        force_rebuild
        or state.get("stage1") != stage1_key
        or any(not path.is_file() for path in stage1_outputs)
        or (theory == baseline_theory and any(not path.is_file() for path in ocaml_outputs))
    )

    if need_stage1:
        announce("two-stage export", f"generating Stage 1 for {theory}")
        rc, _ = run_command(
            ["make", "gen", "DIR=test/sbpf/theory", f"Name={theory}"], cwd=root
        )
        if rc != 0:
            return False
        state = {"stage1": stage1_key}
        missing_stage1 = [path for path in stage1_outputs if not path.is_file()]
        if theory == baseline_theory:
            missing_stage1 += [path for path in ocaml_outputs if not path.is_file()]
        if missing_stage1:
            for path in missing_stage1:
                print(f"ERROR: expected Stage-1 export not found: {path}")
            return False

    if theory != baseline_theory and any(not path.is_file() for path in ocaml_outputs):
        announce("two-stage export", f"generating the OCaml baseline {baseline_theory}")
        rc, _ = run_command(
            ["make", "gen", "DIR=test/sbpf/theory", f"Name={baseline_theory}"], cwd=root
        )
        if rc != 0:
            return False

    need_stage2 = (
        force_rebuild
        or need_stage1
        or state.get("stage2") != stage2_key
        or any(not path.is_file() for path in stage2_outputs)
    )
    if need_stage2:
        announce("two-stage export", f"generating Stage 2 for {theory}")
        rc, _ = run_command(
            ["make", "opt", "DIR=test/sbpf/theory", f"Name={theory}"], cwd=root
        )
        if rc != 0:
            return False
        missing_stage2 = [path for path in stage2_outputs if not path.is_file()]
        if missing_stage2:
            for path in missing_stage2:
                print(f"ERROR: expected Stage-2 export not found: {path}")
            return False
        state["stage1"] = stage1_key
        state["stage2"] = stage2_key
        _write_state(state_path, state)
    else:
        announce("two-stage export", "reusing the existing Stage 1 and Stage 2 exports")

    missing = [
        path
        for path in stage1_outputs + stage2_outputs + ocaml_outputs
        if not path.is_file()
    ]
    if missing:
        for path in missing:
            print(f"ERROR: expected Isabelle export not found: {path}")
        return False
    return True
