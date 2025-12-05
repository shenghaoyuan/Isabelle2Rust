session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup

session Test in "tests_targeted" = Rust +
  description "Type_Tuple_Test test session"
  options [timeout = 300]
  sessions "HOL-Library"
  theories [document = false, condition = ISABELLE_GOEXE]
    "Type_Tuple_Test"
  export_files (in "Rust_Out/Type_Tuple_Test") [2]
    "*:**.rs"
    "*:**.toml"
