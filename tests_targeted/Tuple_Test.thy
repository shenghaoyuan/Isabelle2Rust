theory tuple
  imports Main "Rust.Rust_Setup"
begin

fun swap :: "'a \<times> 'b \<Rightarrow> 'b \<times> 'a" where
  "swap (x, y) = (y, x)"


export_code swap in OCaml
export_code swap in Rust

(*
pub mod product_type {
    #[derive(Clone)]
    pub enum Prod<A, B> {
        Pair(A, B),
    }
}

pub mod tuple {
    use crate::product_type::Prod;

    pub fn swap<A, B>(p: Prod<A, B>) -> Prod<B, A> {
        match p {
            Prod::Pair(x, y) => Prod::Pair(y, x),
        }
    }
}

*)

end