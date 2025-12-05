session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup

session Test in "tests_targeted" = Rust +
  description "List_Cons_Test test session"
  options [timeout = 300]
  sessions "HOL-Library"
  theories [document = false, condition = ISABELLE_GOEXE]
    "List_Cons_Test"
  export_files (in "Rust_Out/List_Cons_Test") [2]
    "*:**.rs"
    "*:**.toml"
