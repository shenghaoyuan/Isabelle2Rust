theory Case_Option_Nested_Test
  imports Main "Rust.Rust_Setup"
begin

(* Nested pattern matching on options *)

fun eval_opt :: "(int option) option \<Rightarrow> int" where
"eval_opt None = 0" |
"eval_opt (Some None) = 1" |
"eval_opt (Some (Some x)) =
   (case x of
       0 \<Rightarrow> 10
     | n \<Rightarrow> n + 2)
"

export_code eval_opt in Rust

end