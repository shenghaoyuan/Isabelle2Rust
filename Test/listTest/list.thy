theory list
  imports Main
    Main "Rust.Rust_Setup"
begin


datatype 'a list =
  Nil 
  | Cons (head : 'a) (tail : "'a list")

fun length :: "'a list \<Rightarrow> nat" where
  "length Nil = 0"
| "length (Cons _ xs) = Suc (length xs)"

export_code length in Rust        
export_code length in OCaml
end