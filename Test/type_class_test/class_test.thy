theory class_test
  imports
  Main "Rust.Rust_Setup"
begin

class inc =
  fixes inc :: "'a \<Rightarrow> 'a"

class dec =
  fixes dec :: "'a \<Rightarrow> 'a"

instantiation nat :: inc
begin
  definition inc_nat where "inc (n::nat) = n + 1"
  instance ..
end

(*
pub trait Inc {
    fn inc(x:&Self) -> Self;
}

impl Inc for Nat {
    fn inc(x: &Nat) -> Nat { 
        let x=x.clone();
        plus_nat(&x, &one_nat())
    }
}

*)
fun add1 :: "('a::inc) \<Rightarrow> 'a" where
  "add1 x = inc x"

fun add2 :: "nat \<Rightarrow> nat" where
  "add2 x = inc x"


export_code add1 in OCaml 
export_code add1 in Rust    

export_code add2 in OCaml 
export_code add2 in Rust    




end
