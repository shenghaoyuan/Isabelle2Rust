# SBPF Case-Study Directory

- `theory/`: Isabelle/HOL SBPF model and export theories.
  - `stage1/`: generated Stage-1 crates.
  - `stage2/`: generated Stage-2 crates.
  - `performance/`: generated performance configurations.
- `tests/`: executable validation support.
  - `data/`: program- and instruction-level test vectors.
  - `exec_semantics/`: Rust and OCaml validation harnesses.
  - `rbpf/`: external Solana/rBPF baseline source.
