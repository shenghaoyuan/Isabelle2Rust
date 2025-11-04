theory lambda_test
  imports Main "Rust.Rust_Setup"
begin

definition id :: "'a \<Rightarrow> 'a" where
  "id \<equiv> (\<lambda>x. x)"


(*
pub mod lambda {
    pub fn id<T>(x: T) -> T {
        (|xa: T| xa)(x)
    }
}
*)

definition inc :: "int \<Rightarrow> int" where
  "inc \<equiv> (\<lambda>x. x + 1)"


definition add_n :: "int \<Rightarrow> (int \<Rightarrow> int)" where
  "add_n n \<equiv> (\<lambda>x. x + n)"



export_code id in OCaml   
export_code id in Rust
export_code inc in OCaml   
export_code inc in Rust

export_code add_n in OCaml   
export_code add_n in Rust
end