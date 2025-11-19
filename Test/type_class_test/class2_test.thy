theory class2_test
  imports
  Main "Rust.Rust_Setup" "Rust.OML_Setup"
begin

class add1 =
  fixes add1 :: "'a \<Rightarrow> 'a"

class add2 =
  fixes add2 :: "'a \<Rightarrow> 'a"

fun add12 :: "('a::add1 add2) \<Rightarrow> 'a" where
  "add12 x = add2 (add1 x)"

export_code add12 in Rust 
export_code add12 in Rust    

                    
end
