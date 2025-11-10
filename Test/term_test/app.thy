theory app
  imports Main "Rust.Rust_Setup"
begin


fun add :: "int \<Rightarrow> int \<Rightarrow> int" where
  "add x y = x + y"

export_code add in Rust

definition test1 :: "int \<Rightarrow> int" where
  "test1 y = add 3 y"

export_code test1 in OCaml
export_code test1 in Rust

definition test2 :: "int" where
  "test2 = add 3 4"


definition test3 :: "int \<Rightarrow> int" where
  "test3 = add 3 4 "

fun add3 :: "int \<Rightarrow> int \<Rightarrow> int \<Rightarrow> int" where
  "add3 x y z = (add x y) + z"

definition test3' :: "int" where
  "test3' = add3 3 4 5"

end