theory Func_Add_Nat_Test
  imports Main "Rust.Rust_Setup"
begin


fun add_nat :: "int \<Rightarrow> int \<Rightarrow> int" where
  "add_nat x y = x + y"

export_code add_nat in Rust

end