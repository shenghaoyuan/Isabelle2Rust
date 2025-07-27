package Num

import (
)

// sum type which can be One, Bit0, Bit1
type Numa any;
type One struct {
};
type Bit0 struct {
  A Numa;
};
type Bit1 struct {
  A Numa;
};

func Bit0_dest(p Bit0)(Numa) {
  return p.A
}
func Bit1_dest(p Bit1)(Numa) {
  return p.A
}
