theory max
  imports
  Main "Rust.Rust_Setup" "Rust.OML_Setup"
begin

fun max:: "int \<Rightarrow> int \<Rightarrow> int" where
" max a b = (if a > b then a else b) 
"

fun mymax1:: "int \<Rightarrow> int \<Rightarrow> int" where
" mymax1 a b = (
  case a > b of
    True \<Rightarrow> a |
    False \<Rightarrow> b )
"


export_code  max in OCaml
export_code  max in Rust    
export_code  mymax1 in OML
export_code  mymax1 in StdML
export_code  mymax1 in Rust
 (* module_name maxTest *)        

                    
end
