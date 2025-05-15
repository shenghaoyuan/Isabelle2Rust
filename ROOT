session Rust = Main +
  options [timeout = 600]
  theories
    Rust_Setup

session Go_Test_Quick in "test/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files [3]
    "*:code/export1/**"

session Rust_Test_Quick in "mytest/quick" = Rust +
  description "Quick test session with BigInts and RBTs"
  options [timeout = 300]
  sessions
    "HOL-Data_Structures"
  theories [document = false, condition = ISABELLE_GOEXE]
    RBT_Test
  export_files [3]
    "*:code/export1/**"