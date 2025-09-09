theory OML_Setup
  imports "Main"
    (*Go.Go_Setup*) (** refer *)
begin

ML_file \<open>code_OML.ML\<close>

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

code_printing
  constant Not \<rightharpoonup> (Rust) "(!(_))"
| constant conj \<rightharpoonup> (Rust) infixl 1 "&&"
| constant disj \<rightharpoonup> (Rust) infixl 0 "||"
| constant implies \<rightharpoonup> (Rust) "!(if (_)/ then (_)/ else true)"
| constant HOL.If \<rightharpoonup> (Rust) "!(if (_)/ then (_)/ else (_))"

code_printing
  type_class equal \<rightharpoonup> (Rust) "(_ == _)"
| constant HOL.equal \<rightharpoonup> (Haskell) infix 4 "=="
| constant HOL.eq \<rightharpoonup> (Haskell) infix 4 "=="

end