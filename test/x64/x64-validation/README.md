# x64 Validation Directory

- `0-data/`: intermediate and final validation datasets.
- `1-x64-ins-gen/`: instruction generator.
- `2-exec-assembler/`: legacy OCaml encoder harness.
- `3-x64-map-gen/`: instruction-map generator.
- `4-x64-stepper-c/`: native x64 execution harness.
- `5-exec-semantics/`: OCaml stepper harness.
- `rust_harness/`: Rust input encoder and stepper entry points.
- `inject_ocaml_glue.py`: OCaml glue generator.
- `run_rust_export.py`: Rust export coordinator.
- `run_rust_validation.py`: validation coordinator.
