theory max
  imports
  "Rust.Rust_Setup"
begin

fun mymax:: "int \<Rightarrow> int \<Rightarrow> int" where
" mymax a b = (if a > b then a else b) 
"

export_code  mymax in Rust
 (* module_name maxTest *)

                    
end
