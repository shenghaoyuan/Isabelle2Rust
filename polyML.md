# PolyML Usage

- Name.invent ctx str n (src/Pure/name.ML, val invent: context -> string -> int -> string list) returns a list of variable name with prefix `str`. e.g. `Name.invent ctxt "x" 3` returns ["x", "x1", "x2"]
- 