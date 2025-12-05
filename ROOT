session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup

session Test in "tests_HOL" = Rust +
  description "Hol_Test test session"
  options [timeout = 300]
  sessions "HOL-Library"
  theories [document = false, condition = ISABELLE_GOEXE]
    "Hol_Test"
  export_files (in "Rust_Out/Hol_Test") [2]
    "*:**.rs"
    "*:**.toml"
