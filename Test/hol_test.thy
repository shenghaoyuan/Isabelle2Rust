
theory hol_test
imports
  "HOL-Library.Code_Test"
  "Rust.Rust_Setup"
  Code_Lazy_Test
begin

text \<open>Test cases for \<^text>\<open>test_code\<close>\<close>

test_code \<comment> \<open>Tests for the serialisation of \<^const>\<open>gcd\<close> on \<^typ>\<open>integer\<close>\<close>
  "gcd 15 5 = (5 :: integer)"
  "gcd 15 (- 10) = (5 :: integer)"
  "gcd (- 10) 15 = (5 :: integer)"
  "gcd (- 10) (- 15) = (5 :: integer)"
  "gcd 0 (- 10) = (10 :: integer)"
  "gcd (- 10) 0 = (10 :: integer)"
  "gcd 0 0 = (0 :: integer)"
in Scala

test_code \<comment> \<open>Tests for the serialisation of \<^const>\<open>gcd\<close> on \<^typ>\<open>integer\<close>\<close>
  "gcd 15 5 = (5 :: int)"
in Rust

definition test1 :: "bool"  where
"test1 = (gcd (15::int) 5 = 5 )"

end
