theory let_test
  imports Main "Rust.Rust_Setup"
begin

definition test_let :: "nat \<Rightarrow> nat" where
  "test_let n \<equiv> (
     let x = n + 1 
     in x * 2
   )"


fun own:: "int \<Rightarrow> int" where
" 
own x = 
  (let y = 1 in 
    let z = y + 1 in
     let y = z + 1 in
      z
  )
"



export_code test_let own in OCaml   
export_code test_let own in Rust

end