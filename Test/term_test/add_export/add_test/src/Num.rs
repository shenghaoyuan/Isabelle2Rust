#[derive(Clone)]
pub enum Num { 
  One, 
  Bit0 (Box<Num>), 
  Bit1 (Box<Num>)
}

pub fn bitm
  (x0: &Num) -> Num {
    match x0 {
      Num::One => Num::One, 
      Num::Bit0 (n) => Num::Bit1 (Box::new((bitm (n)))), 
      Num::Bit1 (n) => Num::Bit1 (Box::new((Bit0 (n))))
    }
  }

pub fn plus_num
  (x0: &Num, x1: &Num) -> Num {
    match (x0, x1) {
      (Num::Bit1 (m), Num::Bit1 (n)) => Num::Bit0 (Box::new((plus_num ((plus_num (m, n)), One)))), 
      (Num::Bit1 (m), Num::Bit0 (n)) => Num::Bit1 (Box::new((plus_num (m, n)))), 
      (Num::Bit1 (m), Num::One) => Num::Bit0 (Box::new((plus_num (m, One)))), 
      (Num::Bit0 (m), Num::Bit1 (n)) => Num::Bit1 (Box::new((plus_num (m, n)))), 
      (Num::Bit0 (m), Num::Bit0 (n)) => Num::Bit0 (Box::new((plus_num (m, n)))), 
      (Num::Bit0 (m), Num::One) => Num::Bit1 (Box::new(m)), 
      (Num::One, Num::Bit1 (n)) => Num::Bit0 ((plus_num (n, One)).clone()), 
      (Num::One, Num::Bit0 (n)) => Num::Bit1 (n.clone()), 
      (Num::One, Num::One) => Num::Bit0 (One.clone())
    }
  }
