#!/usr/bin/env python3
"""Build and run adapters over copies of x64 Rust exports.

The selected crates are treated as immutable inputs. By default the runner
uses the raw Stage-1 exports and ``x64-validation/_build``. Campaign scripts
may select a Stage-2 export and a separate cache with ``X64_RUST_EXPORT_ROOT``
and ``X64_RUST_BUILD_DIR``. Only the copied stepper receives observation glue.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
VALIDATION = ROOT / "test" / "x64" / "x64-validation"
DEFAULT_EXPORT_ROOT = (
    ROOT / "test" / "x64" / "theory" / "stage1" / "x64_generator_bigint"
)
EXPORT_ROOT = Path(os.environ.get("X64_RUST_EXPORT_ROOT") or DEFAULT_EXPORT_ROOT)
if not EXPORT_ROOT.is_absolute():
    EXPORT_ROOT = ROOT / EXPORT_ROOT
HARNESS = VALIDATION / "rust_harness"
BUILD = Path(os.environ.get("X64_RUST_BUILD_DIR") or VALIDATION / "_build")
if not BUILD.is_absolute():
    BUILD = ROOT / BUILD
RUST_TOOLCHAIN = os.environ.get("RUST_TOOLCHAIN", "1.94.0")
CACHE_VERSION = "x64-cross-v2"


@dataclass(frozen=True)
class Adapter:
    """Paths and test inputs for one copied generated crate."""

    name: str
    source: Path
    module: str
    main: Path
    input_env: str
    input_path: Path
    observation: Path | None = None

    @property
    def work(self) -> Path:
        return BUILD / self.name

    @property
    def source_module(self) -> Path:
        return self.source / "src" / self.module

    @property
    def work_module(self) -> Path:
        return self.work / "src" / self.module


ADAPTERS = {
    "encode": Adapter(
        name="encoder",
        source=EXPORT_ROOT / "x64_encode",
        module="X64_encode.rs",
        main=HARNESS / "encoder_main.rs",
        input_env="X64_ENCODER_INPUT",
        input_path=Path(
            os.environ.get("X64_ENCODER_INPUT")
            or VALIDATION / "0-data" / "step1.in"
        ),
    ),
    "encoder": Adapter(
        name="encoder",
        source=EXPORT_ROOT / "x64_encode",
        module="X64_encode.rs",
        main=HARNESS / "encoder_main.rs",
        input_env="X64_ENCODER_INPUT",
        input_path=Path(
            os.environ.get("X64_ENCODER_INPUT")
            or VALIDATION / "0-data" / "step2.in"
        ),
    ),
    "stepper": Adapter(
        name="stepper",
        source=EXPORT_ROOT / "x64_step_test",
        module="X64_step_test.rs",
        main=HARNESS / "stepper_main.rs",
        input_env="X64_STEPPER_INPUT",
        input_path=Path(
            os.environ.get("X64_STEPPER_INPUT")
            or VALIDATION / "0-data" / "step4.json"
        ),
        observation=HARNESS / "step_observe.rs",
    ),
}


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def announce(title: str, detail: str) -> None:
    print(f">>> [x64-rust-{title}] {detail}", flush=True)


def cargo_command() -> list[str]:
    command = shlex.split(os.environ.get("CARGO", "cargo"))
    if command == ["cargo"] and RUST_TOOLCHAIN:
        return ["cargo", f"+{RUST_TOOLCHAIN}"]
    return command


def run(cmd: list[str], *, env: dict[str, str] | None = None) -> int:
    announce("command", shlex.join(cmd))
    return subprocess.run(cmd, cwd=ROOT, env=env).returncode


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def cache_key(adapter: Adapter) -> dict[str, str]:
    """Include every source that can affect the correctness binary."""

    key = {
        "version": CACHE_VERSION,
        "export_root": str(EXPORT_ROOT.resolve()),
        "rust_toolchain": RUST_TOOLCHAIN,
        "runner": sha256(Path(__file__)),
        "generated_module": sha256(adapter.source_module),
        "generated_word_runtime": sha256(adapter.source / "src" / "Rust_Word.rs"),
        "main": sha256(adapter.main),
    }
    if adapter.observation is not None:
        key["observation"] = sha256(adapter.observation)
    return key


def rustflags(adapter: Adapter) -> str:
    flags = ["-Awarnings"]
    if adapter.name == "encoder":
        module = adapter.source_module.read_text(encoding="utf-8")
        if re.search(r"pub\s+fn\s+x64_encode\s*\(\s*ins\s*:\s*&Instruction", module):
            flags.append("--cfg x64_encoder_borrowed")
    return " ".join(flags)


def ensure_dependency(text: str, name: str, specification: str) -> str:
    """Add harness-only dependencies before the generated lint table."""

    pattern = rf"(?m)^{re.escape(name)}\s*=.*$"
    replacement = f"{name} = {specification}"
    if re.search(pattern, text):
        return re.sub(pattern, replacement, text)
    if "[lints.rust]" in text:
        return text.replace("[lints.rust]", replacement + "\n\n[lints.rust]", 1)
    return text.rstrip() + "\n" + replacement + "\n"


def cache_valid(adapter: Adapter, key: dict[str, str]) -> bool:
    stamp = adapter.work / ".x64-rust-cache.json"
    binary = adapter.work / "target" / "debug" / "isabelle_exported"
    if os.environ.get("REBUILD") == "1" or not stamp.exists() or not binary.exists():
        return False
    try:
        return json.loads(stamp.read_text(encoding="utf-8")) == key
    except (OSError, json.JSONDecodeError):
        return False


def prepare(adapter: Adapter, cargo: list[str], env: dict[str, str]) -> Path | None:
    """Copy raw stage1, append permitted glue, and compile the adapter."""

    required = [adapter.source / "Cargo.toml", adapter.source_module, adapter.main]
    if adapter.observation is not None:
        required.append(adapter.observation)
    missing = [path for path in required if not path.exists()]
    if missing:
        for path in missing:
            print(f"ERROR: missing x64 Rust adapter input: {rel(path)}")
        return None

    key = cache_key(adapter)
    binary = adapter.work / "target" / "debug" / "isabelle_exported"
    if cache_valid(adapter, key):
        announce(adapter.name, f"reusing cached adapter {rel(binary)}")
        return binary

    # Preserve the work crate's Cargo target for incremental compilation while
    # replacing every generated source with a fresh stage1 copy.  In
    # particular, this overwrites a previously appended observation function
    # before the glue is appended exactly once below.
    adapter.work.mkdir(parents=True, exist_ok=True)
    shutil.copytree(
        adapter.source,
        adapter.work,
        dirs_exist_ok=True,
        ignore=shutil.ignore_patterns("target"),
    )
    shutil.copy2(adapter.main, adapter.work / "src" / "main.rs")
    if adapter.observation is not None:
        with adapter.work_module.open("a", encoding="utf-8") as module:
            module.write("\n")
            module.write(adapter.observation.read_text(encoding="utf-8"))

        # serde is test-only: the raw stage1 Cargo.toml and generated source are
        # compiled before this copied manifest is extended.
        toml = adapter.work / "Cargo.toml"
        text = toml.read_text(encoding="utf-8")
        # Cargo's plain "0.4.6" requirement is caret-compatible.  Keep the
        # copied semantic runtime on the exact versions already proven by the
        # raw stage1 --locked build before adding JSON-only dependencies.
        text = ensure_dependency(text, "num-bigint", '"=0.4.6"')
        text = ensure_dependency(text, "num-traits", '"=0.2.19"')
        text = ensure_dependency(text, "serde", '{ version = "1.0", features = ["derive"] }')
        text = ensure_dependency(text, "serde_json", '"1.0"')
        toml.write_text(text, encoding="utf-8")
        lock = ROOT / "scripts" / "isabelle-validation.Cargo.lock"
        if not lock.exists():
            print(f"ERROR: missing validation lockfile: {rel(lock)}")
            return None
        shutil.copy2(lock, adapter.work / "Cargo.lock")

    manifest = adapter.work / "Cargo.toml"
    if run(cargo + ["build", "--locked", "--manifest-path", str(manifest)], env=env) != 0:
        return None
    stamp = adapter.work / ".x64-rust-cache.json"
    stamp.write_text(json.dumps(key, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    announce(adapter.name, f"cached adapter in {rel(adapter.work)}")
    return binary


def main() -> int:
    if len(sys.argv) != 2 or sys.argv[1] not in ADAPTERS:
        print("usage: run_rust_validation.py {encode|encoder|stepper}")
        return 2
    action = sys.argv[1]
    adapter = ADAPTERS[action]
    if not adapter.input_path.exists():
        print(f"ERROR: missing x64 adapter input: {rel(adapter.input_path)}")
        return 2

    cargo = cargo_command()
    if run(cargo + ["--version"]) != 0:
        return 2
    env = os.environ.copy()
    env.pop("RUSTC_BOOTSTRAP", None)
    env["RUSTFLAGS"] = rustflags(adapter)
    env[adapter.input_env] = str(adapter.input_path)
    if action == "encode":
        env["X64_ENCODER_OUTPUT"] = str(
            Path(os.environ.get("X64_ENCODER_OUTPUT") or VALIDATION / "0-data" / "step2.in")
        )
    binary = prepare(adapter, cargo, env)
    if binary is None:
        return 1
    announce(adapter.name, f"running {rel(binary)} over {rel(adapter.input_path)}")
    return run([str(binary)], env=env)


if __name__ == "__main__":
    sys.exit(main())
