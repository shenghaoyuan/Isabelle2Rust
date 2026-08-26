theory RBT_Test
  imports "HOL-Library.RBT_Impl" "Rust.Rust_Base_Setup"
begin

text \<open>
  Running example used in the overview of the Isabelle2Rust paper.
\<close>

export_code RBT_Impl.inv1 RBT_Impl.is_rbt in Rust

end
