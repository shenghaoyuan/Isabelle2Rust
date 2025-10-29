theory generic
  imports   
    Main "Rust.Rust_Setup"
begin


(*test print_tyvars*)
ML \<open>
  val ctxt0 = (Symtab.empty, Name.context)
  val ctxt1 = Code_Printer.intro_vars ["'a", "'b", "'c"] ctxt0
  fun print_tyvars (namemap, _) =
    Symtab.dest namemap
    |> map (fn (k, v) => k ^ " => " ^ v)
    |> String.concatWith ", "
  val _ = tracing ("TYVARS: " ^ print_tyvars ctxt1)
\<close>

ML \<open>
val pretty_term = Syntax.pretty_term 
val pwriteln = Pretty.writeln;
pwriteln (pretty_term @{context} @{term "1::nat"})
\<close>


datatype 'a option = None | Some 'a


fun get :: "'a option \<Rightarrow> 'a" where
  "get (Some x) = x"
| "get None = undefined"

(*fun get :: "option \<Rightarrow> int" where
" get (Some x) = x"| 
" get None = 0"*)

export_code get in Rust
export_code get in OCaml
                     
end