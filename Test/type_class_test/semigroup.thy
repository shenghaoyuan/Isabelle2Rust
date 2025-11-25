theory semigroup
  imports
  Main "Rust.Rust_Setup" "Go.Go_Setup"
begin

class inc =
  fixes inc :: "'a \<Rightarrow> 'a"

class dec =
  fixes dec :: "'a \<Rightarrow> 'a"

class semigroup =
  fixes plus :: "'a \<Rightarrow> 'a \<Rightarrow> 'a" (infixl "+s" 65)


class monoid = semigroup +
  fixes zero :: "'a"

(*
trait Semigroup {
    fn plus(x: &Self, y: &Self) -> Self;
}

pub trait Monoid: Semigroup {
    fn neutral() -> Self;
}
*)


definition cls :: "'a::monoid \<Rightarrow> 'a \<Rightarrow> 'a" where
"cls x y = plus x y"


export_code cls in OCaml
export_code cls in Haskell
export_code cls in Rust
export_code cls in Go

end