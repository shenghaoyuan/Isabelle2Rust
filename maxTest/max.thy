theory max
  imports
  "Rust.Rust_Setup"
begin

fun max:: "int \<Rightarrow> int \<Rightarrow> int" where
" max a b = (if a > b then a else b) 
"

export_code  max in Rust
  module_name Max

                    
end
