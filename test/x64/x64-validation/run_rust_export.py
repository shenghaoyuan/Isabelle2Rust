#!/usr/bin/env python3
"""Export and compile the unmodified Rust x64 validation baselines.

This preflight is intentionally separate from the correctness harness.  It
builds the selected Rust generator profile, verifies its expected artifacts,
and compiles the generated Cargo projects before any test glue is copied into a
working tree.  A successful result therefore establishes that the raw exports
compile on their own.
"""

from __future__ import annotations

import hashlib
import json
import os
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
THEORY_DIR = ROOT / "test" / "x64" / "theory"
LOCK_SOURCE = ROOT / "scripts" / "isabelle-exported.Cargo.lock"
RUST_TOOLCHAIN = os.environ.get("RUST_TOOLCHAIN", "1.94.0")
ISABELLE_THREADS = os.environ.get("X64_ISABELLE_THREADS", "1")
ISABELLE_TIMEOUT = os.environ.get("X64_ISABELLE_TIMEOUT", "1200")
ISABELLE_MAX_HEAP = os.environ.get("X64_ISABELLE_MAX_HEAP", "3200")
ISABELLE_JAVA_HEAP = os.environ.get("X64_ISABELLE_JAVA_HEAP", "768")
ISABELLE_LAUNCHER = ROOT / "test" / "x64" / "x64-validation" / "_build" / "isabelle-bounded"
EXPORT_CACHE = ROOT / "test" / "x64" / "x64-validation" / "_build" / "export-cache.json"
STAGE2_EXPORT_ROOT = THEORY_DIR / "stage2" / "x64_generator_bigint"


@dataclass(frozen=True)
class ExportSpec:
    """Expected artifacts for one raw x64 Rust code export."""

    theory: str
    crate: str
    module: str

    @property
    def export_root(self) -> Path:
        return THEORY_DIR / "stage1" / self.theory

    @property
    def crate_dir(self) -> Path:
        return self.export_root / self.crate


CORRECTNESS_EXPORTS = (
    ExportSpec("x64_generator_bigint", "x64_encode", "X64_encode.rs"),
    ExportSpec("x64_generator_bigint", "x64_step_test", "X64_step_test.rs"),
)

PERFORMANCE_EXPORTS = (
    ExportSpec("x64_generator_checked128", "x64_step_test", "X64_step_test.rs"),
)

OCAML_THEORY = "x64_generator_ocaml"
OCAML_EXPORT_ROOT = THEORY_DIR / "stage1" / OCAML_THEORY
OCAML_EXPORTS = (
    OCAML_EXPORT_ROOT / "x64_encode.ocaml",
    OCAML_EXPORT_ROOT / "x64_step_test.ocaml",
)
STAGE2_EXPORTS = (
    STAGE2_EXPORT_ROOT / "x64_encode" / "Cargo.toml",
    STAGE2_EXPORT_ROOT / "x64_step_test" / "Cargo.toml",
)


def rel(path: Path) -> str:
    """Render repository paths without hiding external override locations."""

    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def export_source_fingerprint() -> str:
    """Hash the sources and pinned inputs that determine x64 exports."""

    files = sorted(
        path
        for path in (ROOT / "translate").rglob("*")
        if path.is_file() and path.suffix in {".ML", ".thy"}
    )
    files += sorted((ROOT / "test" / "x64" / "theory").glob("*.thy"))
    files += [
        ROOT / "ROOT",
        ROOT / "rust-toolchain.toml",
        ROOT / "scripts" / "ensure-cargo-lock.py",
        LOCK_SOURCE,
    ]
    digest = hashlib.sha256()
    digest.update(f"rust_toolchain\0{RUST_TOOLCHAIN}\0".encode())
    for path in sorted(set(files)):
        digest.update(f"{rel(path)}\0".encode())
        if not path.is_file():
            digest.update(b"missing\0")
            continue
        with path.open("rb") as source:
            for chunk in iter(lambda: source.read(1024 * 1024), b""):
                digest.update(chunk)
        digest.update(b"\0")
    return digest.hexdigest()


def stage2_source_fingerprint() -> str:
    """Hash the Stage-1 exports and optimizer sources that determine Stage 2."""

    rustlight = ROOT.parent / "RustLightAST"
    roots = [
        THEORY_DIR / "stage1" / "x64_generator_bigint",
        ROOT / "optimize" / "src",
        rustlight / "src",
    ]
    files = [
        path
        for directory in roots
        for path in directory.rglob("*")
        if path.is_file() and "target" not in path.relative_to(directory).parts
    ]
    files += [
        ROOT / "optimize" / "Cargo.toml",
        ROOT / "optimize" / "Cargo.lock",
        rustlight / "Cargo.toml",
        rustlight / "Cargo.lock",
        ROOT / "rust-toolchain.toml",
    ]
    digest = hashlib.sha256()
    for path in sorted(set(files)):
        digest.update(f"{rel(path)}\0".encode())
        if not path.is_file():
            digest.update(b"missing\0")
            continue
        with path.open("rb") as source:
            for chunk in iter(lambda: source.read(1024 * 1024), b""):
                digest.update(chunk)
        digest.update(b"\0")
    return digest.hexdigest()


def read_export_cache() -> dict[str, str]:
    try:
        value = json.loads(EXPORT_CACHE.read_text(encoding="utf-8"))
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return {}
    return value if isinstance(value, dict) else {}


def write_export_cache(cache: dict[str, str]) -> None:
    EXPORT_CACHE.parent.mkdir(parents=True, exist_ok=True)
    temporary = EXPORT_CACHE.with_suffix(".tmp")
    temporary.write_text(
        json.dumps(cache, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    os.replace(temporary, EXPORT_CACHE)


def announce(title: str, detail: str) -> None:
    print(f">>> [x64-rust-export] {title}: {detail}", flush=True)


def run(cmd: list[str], *, cwd: Path, env: dict[str, str] | None = None) -> int:
    """Run one preflight command with output streamed in execution order."""

    announce("command", shlex.join(cmd))
    return subprocess.run(cmd, cwd=cwd, env=env).returncode


def cargo_command() -> list[str]:
    """Honor CARGO overrides while selecting stable Rust by default."""

    command = shlex.split(os.environ.get("CARGO", "cargo"))
    if command == ["cargo"] and RUST_TOOLCHAIN:
        return ["cargo", f"+{RUST_TOOLCHAIN}"]
    return command


def expected_files(spec: ExportSpec) -> tuple[Path, Path]:
    return spec.crate_dir / "Cargo.toml", spec.crate_dir / "src" / spec.module


def isabelle_environment() -> dict[str, str]:
    """Create a bounded launcher after loading the normal Isabelle settings.

    The x64 definitions retain a large code-generator graph.  Isabelle's
    bundled Poly/ML configuration sets only a minimum heap size, so a process
    can otherwise consume all memory assigned to WSL before the operating
    system can terminate it cleanly.  The launcher retains the developer's AFP
    roots and session database, then overrides only the process memory values
    after settings have been loaded.  The second Isabelle invocation sees the
    settings marker and therefore cannot overwrite those bounded values.
    """

    isabelle = shutil.which("isabelle")
    if isabelle is None:
        raise RuntimeError("isabelle executable not found in PATH")
    isabelle_home = Path(isabelle).resolve().parents[1]
    ISABELLE_LAUNCHER.parent.mkdir(parents=True, exist_ok=True)
    ISABELLE_LAUNCHER.write_text(
        "#!/usr/bin/env bash\n"
        "# Generated x64 export launcher; removed by make clean.\n"
        # Isabelle's settings scripts intentionally probe unset variables, so
        # nounset cannot be enabled around the component-loading phase.
        "set -e\n"
        f'export ISABELLE_HOME={shlex.quote(str(isabelle_home))}\n'
        'source "$ISABELLE_HOME/lib/scripts/getsettings"\n'
        f'export ML_OPTIONS="--minheap 500 --maxheap {ISABELLE_MAX_HEAP} '
        '--gcthreads 1 --gcpercent 25"\n'
        'export ISABELLE_TOOL_JAVA_OPTIONS="-Djava.awt.headless=true -Xms256m '
        f'-Xmx{ISABELLE_JAVA_HEAP}m -Xss16m"\n'
        'exec "$ISABELLE_HOME/bin/isabelle" "$@"\n',
        encoding="utf-8",
    )
    ISABELLE_LAUNCHER.chmod(0o755)
    env = os.environ.copy()
    env.pop("RUSTC_BOOTSTRAP", None)
    # The launcher must perform the first settings load itself.
    env.pop("ISABELLE_SETTINGS_PRESENT", None)
    return env


def check_isabelle_environment(env: dict[str, str]) -> bool:
    """Reject the export unless Isabelle reports the intended hard limits."""

    cmd = [str(ISABELLE_LAUNCHER), "getenv", "ML_OPTIONS", "ISABELLE_TOOL_JAVA_OPTIONS"]
    announce("command", shlex.join(cmd))
    completed = subprocess.run(cmd, cwd=ROOT, env=env, text=True, capture_output=True)
    if completed.stdout:
        print(completed.stdout, end="")
    if completed.stderr:
        print(completed.stderr, end="", file=sys.stderr)
    required = (
        f"--maxheap {ISABELLE_MAX_HEAP}",
        "--gcthreads 1",
        f"-Xmx{ISABELLE_JAVA_HEAP}m",
    )
    missing = [value for value in required if value not in completed.stdout]
    if completed.returncode != 0 or missing:
        if missing:
            print(
                "ERROR: Isabelle did not load the bounded export settings: "
                + ", ".join(missing)
            )
        return False
    return True


def build_theory(
    theory: str, export_root: Path, *, isabelle_env: dict[str, str]
) -> bool:
    """Build one x64 generator theory with the bounded Isabelle launcher."""

    if export_root.exists():
        shutil.rmtree(export_root)
    # x64 code generation retains a large HOL/code-generator graph.  Pass the
    # worker limit as an explicit make-variable override: Isabelle settings
    # intentionally replace a same-named process environment variable, while
    # ``-o threads=...`` on the actual build command is authoritative.
    isabelle_build = (
        f"{shlex.quote(str(ISABELLE_LAUNCHER))} build -v -e "
        f"-o threads={ISABELLE_THREADS} -d test-root Rust"
    )
    rc = run(
        [
            "make",
            "build",
            "TEST_DIR=test/x64/theory",
            f"TEST_THEORY={theory}",
            f"TEST_TIMEOUT={ISABELLE_TIMEOUT}",
            f"ISABELLE_TEST_VERBOSE={isabelle_build}",
        ],
        cwd=ROOT,
        env=isabelle_env,
    )
    return rc == 0


def ensure_export(
    spec: ExportSpec,
    *,
    rebuild: bool,
    rebuild_reason: str,
    isabelle_env: dict[str, str],
) -> bool:
    """Generate a Rust export only when absent or explicitly requested."""

    missing = [path for path in expected_files(spec) if not path.exists()]
    if not rebuild and not missing:
        announce("Isabelle export", f"reusing {rel(spec.crate_dir)}")
        return True

    reason = rebuild_reason if rebuild else "missing " + ", ".join(rel(p) for p in missing)
    announce("Isabelle export", f"building {spec.theory} ({reason})")
    # A new export must not inherit an old main.rs, lockfile, target tree, or
    # previously injected test fragment.  The directory contains only
    # reproducible Isabelle export artifacts for this one generator theory.
    if not build_theory(spec.theory, spec.export_root, isabelle_env=isabelle_env):
        return False

    missing_after = [path for path in expected_files(spec) if not path.exists()]
    for path in missing_after:
        print(f"ERROR: expected Rust export not found: {rel(path)}")
    return not missing_after


def ensure_ocaml_export(
    *, rebuild: bool, rebuild_reason: str, isabelle_env: dict[str, str]
) -> bool:
    """Generate the combined fixed OCaml encoder and stepper export."""

    missing = [path for path in OCAML_EXPORTS if not path.exists()]
    if not rebuild and not missing:
        announce("Isabelle export", f"reusing {rel(OCAML_EXPORT_ROOT)}")
        return True

    reason = rebuild_reason if rebuild else "missing " + ", ".join(rel(p) for p in missing)
    announce("Isabelle export", f"building {OCAML_THEORY} ({reason})")
    if not build_theory(OCAML_THEORY, OCAML_EXPORT_ROOT, isabelle_env=isabelle_env):
        return False
    missing_after = [path for path in OCAML_EXPORTS if not path.exists()]
    for path in missing_after:
        print(f"ERROR: expected OCaml export not found: {rel(path)}")
    return not missing_after


def install_lockfile(spec: ExportSpec) -> bool:
    """Install only reproducibility metadata; generated Rust sources stay raw."""

    if not LOCK_SOURCE.exists():
        print(f"ERROR: shared generated-crate lockfile is missing: {rel(LOCK_SOURCE)}")
        return False
    destination = spec.crate_dir / "Cargo.lock"
    shutil.copy2(LOCK_SOURCE, destination)
    return True


def compile_export(spec: ExportSpec, cargo: list[str]) -> bool:
    """Compile the untouched generated crate before correctness glue exists."""

    if not install_lockfile(spec):
        return False
    env = os.environ.copy()
    env.pop("RUSTC_BOOTSTRAP", None)
    env["RUSTFLAGS"] = "-Awarnings"
    manifest = spec.crate_dir / "Cargo.toml"
    announce("raw Cargo build", rel(manifest))
    return (
        run(
            cargo + ["build", "--locked", "--manifest-path", str(manifest)],
            cwd=ROOT,
            env=env,
        )
        == 0
    )


def ensure_stage2_export(cache: dict[str, str], *, rebuild: bool) -> bool:
    """Generate Stage 2 only when its Stage-1 or optimizer inputs changed."""

    key = stage2_source_fingerprint()
    missing = [path for path in STAGE2_EXPORTS if not path.is_file()]
    if not rebuild and cache.get("stage2") == key and not missing:
        announce("Stage-2 export", f"reusing {rel(STAGE2_EXPORT_ROOT)}")
        return True

    reason = "REBUILD=1" if rebuild else (
        "missing generated files" if missing else "relevant sources changed"
    )
    announce("Stage-2 export", f"optimizing x64_generator_bigint ({reason})")
    if run(
        ["make", "opt", "DIR=test/x64/theory", "Name=x64_generator_bigint"],
        cwd=ROOT,
    ) != 0:
        return False
    missing_after = [path for path in STAGE2_EXPORTS if not path.is_file()]
    for path in missing_after:
        print(f"ERROR: expected Stage-2 export not found: {rel(path)}")
    if missing_after:
        return False
    cache["stage2"] = key
    write_export_cache(cache)
    return True


def main() -> int:
    if len(sys.argv) > 2 or (
        len(sys.argv) == 2 and sys.argv[1] not in {"performance", "ocaml", "stage2"}
    ):
        print("usage: run_rust_export.py [performance|ocaml|stage2]")
        return 2
    requested_mode = sys.argv[1] if len(sys.argv) == 2 else "correctness"
    stage2_requested = requested_mode == "stage2"
    mode = "correctness" if stage2_requested else requested_mode
    exports = PERFORMANCE_EXPORTS if mode == "performance" else CORRECTNESS_EXPORTS
    forced_rebuild = os.environ.get("REBUILD") == "1"
    source_key = export_source_fingerprint()
    export_cache = read_export_cache()
    source_changed = export_cache.get(mode) != source_key
    rebuild = forced_rebuild or source_changed
    rebuild_reason = "REBUILD=1" if forced_rebuild else "relevant sources changed"

    isabelle_env = isabelle_environment()
    announce(
        "Isabelle memory limits",
        f"Poly/ML={ISABELLE_MAX_HEAP} MiB, Java={ISABELLE_JAVA_HEAP} MiB",
    )
    # Print the effective values before the expensive build.  This turns an
    # incorrectly loaded user component into an immediate gate failure instead
    # of risking another unbounded Poly/ML process.
    if not check_isabelle_environment(isabelle_env):
        return 2
    if mode == "ocaml":
        passed = ensure_ocaml_export(
            rebuild=rebuild,
            rebuild_reason=rebuild_reason,
            isabelle_env=isabelle_env,
        )
        if passed:
            export_cache[mode] = source_key
            write_export_cache(export_cache)
        print("\n========================================")
        print("x64 raw OCaml export summary")
        print("  Overall: PASS" if passed else "  Overall: FAIL")
        return 0 if passed else 1

    cargo = cargo_command()
    if run(cargo + ["--version"], cwd=ROOT) != 0:
        return 2
    passed = 0
    rebuilt_theories: set[str] = set()
    theories_to_rebuild = {
        spec.theory
        for spec in exports
        if rebuild or any(not path.exists() for path in expected_files(spec))
    }
    for spec in exports:
        rebuild_theory = (
            spec.theory in theories_to_rebuild and spec.theory not in rebuilt_theories
        )
        if not ensure_export(
            spec,
            rebuild=rebuild_theory,
            rebuild_reason=(
                rebuild_reason if rebuild else "missing generated files"
            ),
            isabelle_env=isabelle_env,
        ):
            print(f"ERROR: Rust export failed for {spec.theory}")
            break
        rebuilt_theories.add(spec.theory)
        if not compile_export(spec, cargo):
            print(f"ERROR: raw Rust export did not compile for {spec.theory}")
            break
        passed += 1

    failed = len(exports) - passed
    stage2_passed = False
    if failed == 0:
        export_cache[mode] = source_key
        write_export_cache(export_cache)
        if stage2_requested:
            stage2_passed = ensure_stage2_export(
                export_cache, rebuild=forced_rebuild
            )
    print("\n========================================")
    print("x64 two-stage export summary")
    print(
        f"  Stage-1 raw Rust export: Passed {passed} / "
        f"Failed {failed} / Total {len(exports)}"
    )
    if stage2_requested:
        print(
            "  Stage-2 optimized Rust export: PASS"
            if stage2_passed
            else "  Stage-2 optimized Rust export: FAIL"
        )
    overall = failed == 0 and (not stage2_requested or stage2_passed)
    print("  Overall: PASS" if overall else "  Overall: FAIL")
    return 0 if overall else 1


if __name__ == "__main__":
    sys.exit(main())
