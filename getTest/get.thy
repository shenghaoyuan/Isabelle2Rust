theory get
  imports   
    Main "Rust.Rust_Setup"
begin


datatype  option = None | Some int


fun get :: "option \<Rightarrow> int" where
" get (Some x) = x"| 
" get None = 0"

export_code get in Rust
export_code get in OCaml
                     
end