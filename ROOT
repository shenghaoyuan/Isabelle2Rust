session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup

session Go_Test_Quick_Local in "test/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files
    "*:**.rs"
    "*:**.ocaml"

session Rust_Test_Quick in "mytest/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files
    "*:**.rs"
    "*:**.ocaml"

session Max_Test in "maxTest" = Rust +
  description "max test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    max
  export_files
    "*:**.rs"
    "*:**.ocaml"

session Get_Test in "getTest" = Rust +
  description "get test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    get
  export_files
    "*:**.rs"
    "*:**.ocaml"

session Generic_Test in "genericTest" = Rust +
  description "generic test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    generic
  export_files
    "*:**.rs"
    "*:**.ocaml"