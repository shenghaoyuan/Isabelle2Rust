theory semigroup2
  imports
  Main "Rust.Rust_Setup"
begin

class semigroup =
  fixes plus :: "'a \<Rightarrow> 'a \<Rightarrow> 'a" (infixl "+s" 65)


class monoid = semigroup +
  fixes zero :: "'a"


datatype Nat = Zero | Suc Nat

instantiation Nat :: semigroup
begin

fun plus_Nat :: "Nat \<Rightarrow> Nat \<Rightarrow> Nat" where
  "a +s Zero = a"
| "Zero +s a = a"
| "Suc a +s b = Suc (a +s b)"
instance ..

end

(*
impl Semigroup for Nat {
    fn plus(x: &Nat, y: &Nat) -> Nat {
        let (x,y)=(x.clone(),y.clone());
        match (x, y) {
            (a, Nat::Zero) => a,        // a + Zero = a
            (Nat::Zero, a) => a,        // Zero + a = a 
            (Nat::Suc(a), b) => {     // Suc a + b = Suc (a + b)
                Nat::Suc(Box::new(Self::plus(&a, &b)))
            }
        }
    }
}
*)

instantiation Nat :: monoid
begin

definition zero_Nat :: "Nat" where
  "zero = Zero"

instance ..
end

(*impl Monoid for Nat {
    fn zero() -> Nat {
        Nat::Zero
    }
}*)

fun zerolist :: "('a :: monoid) list \<Rightarrow> 'a list" where
  "zerolist xs = map (\<lambda>x. zero) xs"

fun sum :: "('a :: monoid) list \<Rightarrow> 'a" where
  "sum xs = fold plus xs zero"

export_code zerolist sum in OCaml
export_code zerolist sum in Rust

end