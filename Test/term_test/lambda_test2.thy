theory lambda_test2
  imports Main "Rust.Rust_Setup"
begin


definition closure_1 where
"
closure_1 =(let y::int = 3 in
            let f = (\<lambda>x. x + y) in
              f 10)
"
export_code closure_1 in Rust

definition closure_2 where
"
closure_2 =(\<lambda>x::int. x + 1) 10
"
export_code closure_2 in Rust

end