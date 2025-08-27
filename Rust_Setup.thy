theory Rust_Setup
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
| constant "False::bool" \<rightharpoonup> (Rust) "false"
| constant "True::bool" \<rightharpoonup> (Rust) "true" (*
| type_constructor Int.int \<rightharpoonup> (Rust) "u64" *)

|  constant HOL.Not \<rightharpoonup> (Rust) "(!(_))"
| constant HOL.conj \<rightharpoonup> (Rust) infixl 1 "&&"
| constant HOL.disj \<rightharpoonup> (Rust) infixl 0 "||"
| constant HOL.implies \<rightharpoonup> (Rust) "((!(_)) || (_))"
| constant "HOL.equal :: bool \<Rightarrow> bool \<Rightarrow> bool" \<rightharpoonup> (Rust) "(_ == _)"
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


subsection \<open> num-bigint \<close>

text \<open>
include crates：
    num-bigint  = "0.4"
    num-integer = "0.1"
    num-traits  = "0.2"
\<close>

(* Integers via num-bigint *)
code_printing
  code_module "Bigint" \<rightharpoonup> (Rust) \<open>
package Bigint

import "math/big"

type Int = big.Int;

func MkInt(s string) Int {
  var i Int;
  _, e := i.SetString(s, 10);
  if (e) {
    return i;
  } else {
    panic("invalid integer literal")
  }
}

func Uminus(a Int) Int {
  var b Int
  b.Neg(&a)
  return b
}

func Minus(a, b Int) Int {
  var c Int
  c.Sub(&a, &b)
  return c
}

func Plus(a, b Int) Int {
  var c Int
  c.Add(&a, &b)
  return c
}

func Times (a, b Int) Int {
  var c Int
  c.Mul(&a, &b)
  return c
}

func Divmod_abs(a, b Int) (Int, Int) {
  var div, mod Int
  div.DivMod(&a, &b, &mod)
  div.Abs(&div)
  return div, mod
}

func Equal(a, b Int) bool {
  return a.Cmp(&b) == 0
}

func Less_eq(a, b Int) bool {
  return a.Cmp(&b) != 1
}

func Less(a, b Int) bool {
  return a.Cmp(&b) == -1
}

func Abs(a Int) Int {
  var b Int
  b.Abs(&a)
  return b
}
\<close> for constant "uminus :: integer \<Rightarrow> _" "minus :: integer \<Rightarrow> _" "Code_Numeral.dup" "Code_Numeral.sub"
  "(*) :: integer \<Rightarrow> _" "(+) :: integer \<Rightarrow> _" "Code_Numeral.divmod_abs" "HOL.equal :: integer \<Rightarrow> _"
  "less_eq :: integer \<Rightarrow> _" "less :: integer \<Rightarrow> _" "abs :: integer \<Rightarrow> _"
  "String.literal_of_asciis" "String.asciis_of_literal"
  | type_constructor "integer" \<rightharpoonup> (Rust) "Bigint.Int"
  | constant "uminus :: integer \<Rightarrow> integer" \<rightharpoonup> (Rust) "Bigint.Uminus( _ )"
  | constant "minus :: integer \<Rightarrow> integer \<Rightarrow> integer" \<rightharpoonup> (Rust) "Bigint.Minus( _, _)"
  | constant "Code_Numeral.dup" \<rightharpoonup> (Rust) "!(Bigint.MkInt(\"2\") * _)"
  | constant "Code_Numeral.sub" \<rightharpoonup> (Rust) "panic(\"sub\")"
  | constant "(+) :: integer \<Rightarrow> _ " \<rightharpoonup> (Rust) "Bigint.Plus( _, _)"
  | constant "(*) :: integer \<Rightarrow> _ \<Rightarrow> _ " \<rightharpoonup> (Rust) "Bigint.Times( _, _)"
  | constant Code_Numeral.divmod_abs \<rightharpoonup>
     (Rust) "func () Prod[Bigint.Int, Bigint.Int] { a, b := Bigint.Divmod'_abs( _, _); return Prod[Bigint.Int, Bigint.Int]{a, b}; }()"
  | constant "HOL.equal :: integer \<Rightarrow> _" \<rightharpoonup> (Rust) "Bigint.Equal( _, _)"
  | constant "less_eq :: integer \<Rightarrow> integer \<Rightarrow> bool " \<rightharpoonup> (Rust) "Bigint.Less'_eq( _, _)"
  | constant "less :: integer \<Rightarrow> _ " \<rightharpoonup> (Rust) "Bigint.Less( _, _)"
  | constant "abs :: integer \<Rightarrow> _" \<rightharpoonup> (Rust) "Bigint.Abs( _ )"


code_printing
  constant "0::integer" \<rightharpoonup> (Rust) "Bigint.MkInt(\"0\")"
setup \<open>
Numeral.add_code \<^const_name>\<open>Code_Numeral.Pos\<close> I Code_Printer.literal_numeral "Rust"
#> Numeral.add_code \<^const_name>\<open>Code_Numeral.Neg\<close> (~) Code_Printer.literal_numeral "Rust"
\<close>

end