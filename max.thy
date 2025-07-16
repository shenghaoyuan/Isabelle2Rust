theory max
  imports Main

begin

definition max:: "int \<Rightarrow> int \<Rightarrow> int" where
" max a b = (if a > b then a else b) 
"


(*value "max 1987 283464"*)

end
