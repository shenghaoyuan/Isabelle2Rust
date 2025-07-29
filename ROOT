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

session Max_Test in "maxTest" = Rust +
  description "max test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    max
  export_files [3]
    "*:code/export1/**"

session Get_Test in "getTest" = Rust +
  description "get test"
  options [timeout = 300]
  theories [document = false, condition = ISABELLE_GOEXE]
    get
  export_files [3]
    "*:code/export1/**"