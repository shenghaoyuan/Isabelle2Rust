theory consTest
  imports Main "Rust.Rust_Setup"
begin


definition c :: int where "c \<equiv> 42"

export_code c in OCaml   
export_code c in Rust
end