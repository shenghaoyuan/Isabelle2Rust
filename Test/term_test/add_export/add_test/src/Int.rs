use crate::Num::*;

#[derive(Clone)]
pub enum Int { 
  ZeroInt, 
  Pos (Box<Num>), 
  Neg (Box<Num>)
}

fn dup
  (x0: &Int) -> Int {
    match x0 {
      Int::Neg (n) => Int::Neg ((Bit0 (n)).clone()), 
      Int::Pos (n) => Int::Pos ((Bit0 (n)).clone()), 
      Int::ZeroInt => Int::ZeroInt
    }
  }

fn uminus_int
  (x0: &Int) -> Int {
    match x0 {
      Int::Neg (m) => Int::Pos (m.clone()), 
      Int::Pos (m) => Int::Neg (m.clone()), 
      Int::ZeroInt => Int::ZeroInt
    }
  }

let one_int : Int
  () -> /*typ_error*/ {
    Int::Pos ()
  }

fn sub
  (x0: &Num, x1: &Num) -> Int {
    match (x0, x1) {
      (Num::Bit0 (m), Num::Bit1 (n)) => minus_int ((dup ((sub (m, n)))), (one_int ())), 
      (Num::Bit1 (m), Num::Bit0 (n)) => plus_int ((dup ((sub (m, n)))), (one_int ())), 
      (Num::Bit1 (m), Num::Bit1 (n)) => dup ((sub (m, n))), 
      (Num::Bit0 (m), Num::Bit0 (n)) => dup ((sub (m, n))), 
      (Num::One, Num::Bit1 (n)) => Int::Neg ((Bit0 (n)).clone()), 
      (Num::One, Num::Bit0 (n)) => Int::Neg ((bitm (n)).clone()), 
      (Num::Bit1 (m), Num::One) => Int::Pos (Box::new((Bit0 (m)))), 
      (Num::Bit0 (m), Num::One) => Int::Pos (Box::new((bitm (m)))), 
      (Num::One, Num::One) => Int::ZeroInt
    }
  }

fn plus_int
  (k: &Int, l: &Int) -> Int {
    match (k, l) {
      (Int::Neg (m), Int::Neg (n)) => Int::Neg ((plus_num (m, n)).clone()), 
      (Int::Neg (m), Int::Pos (n)) => sub (n, m), 
      (Int::Pos (m), Int::Neg (n)) => sub (m, n), 
      (Int::Pos (m), Int::Pos (n)) => Int::Pos ((plus_num (m, n)).clone()), 
      (Int::ZeroInt, l) => l.clone(), 
      (k, Int::ZeroInt) => k.clone()
    }
  }

fn minus_int
  (k: &Int, l: &Int) -> Int {
    match (k, l) {
      (Int::Neg (m), Int::Neg (n)) => sub (n, m), 
      (Int::Neg (m), Int::Pos (n)) => Int::Neg ((plus_num (m, n)).clone()), 
      (Int::Pos (m), Int::Neg (n)) => Int::Pos ((plus_num (m, n)).clone()), 
      (Int::Pos (m), Int::Pos (n)) => sub (m, n), 
      (Int::ZeroInt, l) => uminus_int (l), 
      (k, Int::ZeroInt) => k.clone()
    }
  }
