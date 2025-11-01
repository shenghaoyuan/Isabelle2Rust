theory letTest
  imports Main "Rust.Rust_Setup"
begin

definition test_let :: "nat \<Rightarrow> nat" where
  "test_let n \<equiv> (
     let x = n + 1 
     in x * 2
   )"


export_code test_let in OCaml   
export_code test_let in Rust

end