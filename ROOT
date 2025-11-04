session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup
    OML_Setup

session Go_Test_Quick_Local in "test/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files
    "*:**.rs"
    "*:**.ML"
    "*:**.ocaml"
    "*:**.toml"

session Rust_Test_Quick in "mytest/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files
    "*:**.rs"
    "*:**.ML"
    "*:**.ocaml"
    "*:**.toml"

session Max_Test in "Test/max_test" = Rust +
  description "max test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    max
  export_files
    "*:**.rs"
    "*:**.ML"
    "*:**.ocaml"
    "*:**.toml"

session Get_Test in "Test/get_test" = Rust +
  description "get test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    get
  export_files
    "*:**.rs"
    "*:**.ML"
    "*:**.ocaml"
    "*:**.toml"

session Generic_Test in "Test/type_test/generic" = Rust +
  description "generic test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    generic
  export_files
    "*:**.rs"
    "*:**.ML"
    "*:**.ocaml"
    "*:**.toml"