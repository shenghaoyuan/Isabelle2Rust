theory get
  imports   
    Main "Rust.Rust_Setup"
begin


datatype  option = None | Some int | Rec option

datatype  aoption = Nonea | Somea int | MutualReca boption
  and  boption = Noneb | Someb int | MutualRecb aoption


fun get :: "option \<Rightarrow> int" where
" get (Some x) = x" | 
" get None = 0" |
" get (Rec op) = get op" 

fun set :: "option \<Rightarrow> int \<Rightarrow> option" where
  "set (Some _) x = Some x" |
  "set None x = Some x" |
  "set (Rec op) x = Rec (set op x)"

fun mugeta :: "aoption \<Rightarrow> int" 
  and mugetb :: "boption \<Rightarrow> int" where
" mugeta (Somea x) = x" | 
" mugeta Nonea = 0" | 
" mugeta (MutualReca bop) = mugetb bop" |
" mugetb (Someb x) = x" | 
" mugetb Noneb = 0" | 
" mugetb (MutualRecb aop) = mugeta aop" 

export_code get mugeta set in Rust
export_code get mugeta set in OCaml
                     
end