theory cons_test
  imports Main "Rust.Rust_Setup"
begin


definition c :: int where "c \<equiv> 42"

export_code c in OCaml   
export_code c in Rust

fun add :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "add x y = x + y"


export_code add in OCaml   
export_code add in Rust


end