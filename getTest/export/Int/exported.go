package Int

import (
  "isabelle/exported/Num"
)

// sum type which can be Zero_int, Pos, Neg
type Inta any;
type Zero_int struct {
};
type Pos struct {
  A Num.Numa;
};
type Neg struct {
  A Num.Numa;
};

func Pos_dest(p Pos)(Num.Numa) {
  return p.A
}
func Neg_dest(p Neg)(Num.Numa) {
  return p.A
}
