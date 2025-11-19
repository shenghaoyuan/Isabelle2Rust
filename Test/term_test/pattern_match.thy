theory pattern_match
  imports Main "Rust.Rust_Setup"
begin

fun neg :: "bool \<Rightarrow> bool" where
  "neg b = (case b of True \<Rightarrow> False | False \<Rightarrow> True)"

(*
pub fn neg(b: &bool) -> bool {
    let b = ( *b).clone();
    match b {
        true => false,
        false => true,
    }
}
*)

export_code neg in OCaml
export_code neg in Rust


fun get_or_zero :: "int option \<Rightarrow> int" where
  "get_or_zero x = (case x of None \<Rightarrow> 0 | Some n \<Rightarrow> n)"

(*pub fn get_or_zero(x: &Option<Int>) -> Int {
    match x {
        None => Int::ZeroInt(),
        Some(n) => n.clone(),
    }
}*)

export_code get_or_zero in OCaml
export_code get_or_zero in Rust


fun length1 :: "'a list \<Rightarrow> bool" where
  "length1 xs = (case xs of [] \<Rightarrow> False | [x] \<Rightarrow> True | _ \<Rightarrow> False)" 

export_code length1 in OCaml
export_code length1 in Rust 

fun length2 :: "int list \<Rightarrow> int" where
  "length2 xs = (case xs of [] \<Rightarrow> 0 | [x] \<Rightarrow> x*3 | _ \<Rightarrow> 0)" 
export_code length2 in OCaml
export_code length2 in Rust 


fun add1 :: "int \<Rightarrow> int" where
  "add1 x = (let z = 1 in case z of y \<Rightarrow> (y+z))"

export_code add1 in OCaml
export_code add1 in Rust 

fun add2 :: "'a \<Rightarrow> 'a" where
  "add2 x = (case x of y \<Rightarrow> y)"
export_code add2 in OCaml
export_code add2 in Rust 

fun add3 :: "int \<Rightarrow> int" where
  "add3 x = (case x of y \<Rightarrow> (1))"

export_code add3 in OCaml
export_code add3 in Rust 




end