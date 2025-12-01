theory Max2_Test
  imports
  Main "Rust.Rust_Setup"
begin

(* Max on int using case expression *)

fun max2:: "int \<Rightarrow> int \<Rightarrow> int" where
"max2 a b = (
   case a > b of
     True \<Rightarrow> a |
     False \<Rightarrow> b )
"

export_code max2 in Rust

end