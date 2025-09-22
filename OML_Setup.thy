theory OML_Setup
  imports "Main"
    (*Go.Go_Setup*) (** refer *)
begin

ML_file \<open>code_ml.ML\<close>

code_identifier
  code_module Code_Target_Nat \<rightharpoonup> (OML) Arith
| code_module Code_Target_Int \<rightharpoonup> (OML) Arith
| code_module Code_Numeral \<rightharpoonup> (OML) Arith

code_printing
  constant Code.abort \<rightharpoonup> (OML) "panic!( _ )"

(* Bools *)
subsection \<open>bool and logic connectives\<close>
code_printing
  type_constructor bool \<rightharpoonup> (OML) "bool"
| constant False \<rightharpoonup> (OML) "false"
| constant True \<rightharpoonup> (OML) "true"

code_reserved
  (OML) bool

code_printing
  constant Not \<rightharpoonup> (OML) "(!(_))"
| constant conj \<rightharpoonup> (OML) infixl 1 "&&"
| constant disj \<rightharpoonup> (OML) infixl 0 "||"
| constant implies \<rightharpoonup> (OML) "!(if (_)/ then (_)/ else true)"
| constant HOL.If \<rightharpoonup> (OML) "!(if (_)/ then (_)/ else (_))"

code_printing
  type_class equal \<rightharpoonup> (OML) "(_ == _)"
| constant HOL.equal \<rightharpoonup> (Haskell) infix 4 "=="
| constant HOL.eq \<rightharpoonup> (Haskell) infix 4 "=="

end