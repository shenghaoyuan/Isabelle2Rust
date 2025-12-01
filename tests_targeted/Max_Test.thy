theory Max_Test
  imports
  Main "Rust.Rust_Setup" "Rust.OML_Setup"
begin

(* Max on int using if expression *)

fun max:: "int \<Rightarrow> int \<Rightarrow> int" where
" max a b = (if a > b then a else b) 
"

(* Max on int using case expression *)

fun max2:: "int \<Rightarrow> int \<Rightarrow> int" where
"max2 a b = (
   case a > b of
     True \<Rightarrow> a |
     False \<Rightarrow> b )
"

export_code max in Rust 
export_code max2 in Rust

end