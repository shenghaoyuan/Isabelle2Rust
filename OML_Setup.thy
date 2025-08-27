theory OML_Setup
  imports "Main"
    (*Go.Go_Setup*) (** refer *)
begin

ML_file \<open>code_OML.ML\<close>

code_identifier
  code_module Code_Target_Nat \<rightharpoonup> (Caml) Arith
| code_module Code_Target_Int \<rightharpoonup> (Caml) Arith
| code_module Code_Numeral \<rightharpoonup> (Caml) Arith

code_printing
  constant Code.abort \<rightharpoonup> (Caml) "panic!( _ )"

(* Bools *)
subsection \<open>bool and logic connectives\<close>
code_printing
  type_constructor bool \<rightharpoonup> (Caml) "bool"
| constant False \<rightharpoonup> (Caml) "false"
| constant True \<rightharpoonup> (Caml) "true"

code_reserved
  (Caml) bool

code_printing
  constant Not \<rightharpoonup> (Caml) "(!(_))"
| constant conj \<rightharpoonup> (Caml) infixl 1 "&&"
| constant disj \<rightharpoonup> (Caml) infixl 0 "||"
| constant implies \<rightharpoonup> (Caml) "!(if (_)/ then (_)/ else true)"
| constant HOL.If \<rightharpoonup> (Caml) "!(if (_)/ then (_)/ else (_))"

code_printing
  type_class equal \<rightharpoonup> (Caml) "(_ == _)"
| constant HOL.equal \<rightharpoonup> (Haskell) infix 4 "=="
| constant HOL.eq \<rightharpoonup> (Haskell) infix 4 "=="

end