theory cons_test
  imports Main "Rust.Rust_Setup"
begin


definition c :: int where "c \<equiv> 42"

export_code c in OCaml   
export_code c in Rust
(*

pub const C: int = 42 //
pub fn c() -> int {
    42
}
*)


definition zero :: "'a::zero" where "zero \<equiv> 0"  
(*
pub trait Zero {
    fn zero() -> Self;
}

pub fn zero<T: Zero>() -> T { T::zero() }
*)
export_code zero in OCaml   
export_code zero in Rust



definition n :: nat where "n \<equiv> length [1::nat,2,3]"
export_code n in OCaml   
export_code n in Rust


fun add :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "add x y = x + y"

export_code add in OCaml   
export_code add in Rust


end