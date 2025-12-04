theory Rust_Setup
  imports "Main"
    (*Go.Go_Setup*) (** refer *)
begin

ML_file \<open>code_rust.ML\<close>

code_identifier
  code_module Code_Target_Nat \<rightharpoonup> (Rust) Arith
| code_module Code_Target_Int \<rightharpoonup> (Rust) Arith
| code_module Code_Numeral \<rightharpoonup> (Rust) Arith

code_printing
  constant Code.abort \<rightharpoonup> (Rust) "panic!( _ )"

(* Bools *)
subsection \<open>bool and logic connectives\<close>
code_printing
  type_constructor bool \<rightharpoonup> (Rust) "bool"
| constant False \<rightharpoonup> (Rust) "false"
| constant True \<rightharpoonup> (Rust) "true"

code_reserved
  (Rust) bool

(*code_printing
  constant Not \<rightharpoonup> (Rust) "(!(_))"
| constant conj \<rightharpoonup> (Rust) infixl 1 "&&"
| constant disj \<rightharpoonup> (Rust) infixl 0 "||"
| constant implies \<rightharpoonup> (Rust) "!(if (_)/ then (_)/ else true)"
| constant HOL.If \<rightharpoonup> (Rust) "!if (_)/ {(_)}/ else {(_)}"*)

(*code_printing
  type_class equal \<rightharpoonup> (Rust) "(_ == _)"
| constant HOL.equal \<rightharpoonup> (Rust) infix 4 "=="
| constant HOL.eq \<rightharpoonup> (Rust) infix 4 "=="*)

(*constant HOL.Not \<rightharpoonup> (Rust) "'! _"*)
(*| constant HOL.implies \<rightharpoonup> (Rust) "!('!((_)) || (_))"*)
(*| constant "HOL.equal :: bool \<Rightarrow> bool \<Rightarrow> bool" \<rightharpoonup> (Rust) infix 4 "=="*)


(* definitions to make these functions available *)
definition "go_private_map_list" where
  "go_private_map_list f a = map f a"
definition "go_private_fold_list" where
  "go_private_fold_list f a b = fold f a b"


subsection \<open>String\<close>
(*infix ??>*)
code_printing
  type_constructor String.literal \<rightharpoonup> (Rust) "String"
(*| constant "STR ''''" \<rightharpoonup> (Rust) "\"\""*)
| constant "STR ''''" \<rightharpoonup> (Rust) "String::new()"
| constant "Groups.plus_class.plus :: String.literal \<Rightarrow> _ \<Rightarrow> _" \<rightharpoonup>
    (Rust) infix 6 "((_).clone() + (_).as_str())"                             (*(Rust) infix 6 "+"*)
| constant "HOL.equal :: String.literal \<Rightarrow> String.literal \<Rightarrow> bool" \<rightharpoonup>
    (Rust) infix 4 "(_ == _)"
| constant "(\<le>) :: String.literal \<Rightarrow> String.literal \<Rightarrow> bool" \<rightharpoonup>
    (Rust) infix 4 "(_ <= _)"
| constant "(<) :: String.literal \<Rightarrow> String.literal \<Rightarrow> bool" \<rightharpoonup>
    (Rust) infix 4 "(_ < _)"

setup \<open>
  fold Literal.add_code ["Rust"]
\<close>

end