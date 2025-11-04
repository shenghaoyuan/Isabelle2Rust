theory fun_type
  imports Main "Rust.Rust_Setup"
begin

fun apply_twice :: "('a \<Rightarrow> 'a) \<Rightarrow> 'a \<Rightarrow> 'a" where
  "apply_twice f x = f (f x)"

export_code apply_twice in OCaml
export_code apply_twice in Rust

(*mod fun_ty {
    pub fn apply_twice<A>(f: fn(A) -> A, x: A) -> A {
        f(f(x))
    }
}*)

end