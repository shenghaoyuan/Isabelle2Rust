package get

import (
  "isabelle/exported/Int"
)

// sum type which can be None, Some
type Option any;
type None struct {
};
type Some struct {
  A Int.Inta;
};

func Some_dest(p Some)(Int.Inta) {
  return p.A
}

func Get (x0 Option) Int.Inta {
  {
    q, m := x0.(Some);
    if m {
      xa := Some_dest(q);
      return xa;
    }
  };
  {
    if x0 == (Option(None{})) {
      return Int.Inta(Int.Zero_int{});
    }
  };
  panic("match failed");
}
