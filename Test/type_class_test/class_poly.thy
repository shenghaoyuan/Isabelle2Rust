theory class_poly
  imports
  Main "Rust.Rust_Setup"
begin

class inc =
  fixes inc :: "'a \<Rightarrow> 'a"

instantiation option :: (inc) inc
begin

definition inc_option :: "'a option \<Rightarrow> 'a option"
  where
    "inc_option x =
       (case x of
          None \<Rightarrow> None
        | Some a \<Rightarrow> Some (inc a))"

instance ..
end

end