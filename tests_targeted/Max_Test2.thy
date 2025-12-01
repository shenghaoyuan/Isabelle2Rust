theory Max_Test2
  imports
  Main "Rust.Rust_Setup" "Rust.OML_Setup"
begin

(*  max function using case *)
fun max2:: "int \<Rightarrow> int \<Rightarrow> int" where
"max2 a b = (
   case a > b of
     True \<Rightarrow> a |
     False \<Rightarrow> b )
"

export_code  max2 in Rust 

end