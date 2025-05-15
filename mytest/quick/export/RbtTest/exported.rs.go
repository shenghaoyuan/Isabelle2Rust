package RbtTest

import (
  "isabelle/exported/Bigint"
)

// sum type which can be Red, Black
type Color any;
type Red struct {
};
type Black struct {
};



func Equal_colora (x0 Color, x1 Color) bool/*Print Function Head*/ {
  {
    if x0 == (Color(/*Tag: Application Expr*/Red{})) {
      if x1 == (Color(/*Tag: Application Expr*/Black{})) {
        return false;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching1*/
  };
  {
    if x0 == (Color(/*Tag: Application Expr*/Black{})) {
      if x1 == (Color(/*Tag: Application Expr*/Red{})) {
        return false;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching1*/
  };
  {
    if x0 == (Color(/*Tag: Application Expr*/Black{})) {
      if x1 == (Color(/*Tag: Application Expr*/Black{})) {
        return true;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching1*/
  };
  {
    if x0 == (Color(/*Tag: Application Expr*/Red{})) {
      if x1 == (Color(/*Tag: Application Expr*/Red{})) {
        return true;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching1*/
  };
  panic("match failed");
}

type Equal[a any] struct {
  Equala func(a, a) bool
}

func Equal_color () Equal[Color]/*Print Function Head*/ {
  return Equal[Color] {
    Equala: func /*Tag: Anonymous Function*/ (A Color, Aa Color) bool/*Print Function Head*/ {
              return /*Tag: Application Expr*/Equal_colora(A, Aa);
            },
  }
}

type Prod[a, b any] struct {
  A a;
  Aa b;
};
func Pair_dest[a, b any](p Prod[a, b])(a, b) {
  return  p.A, p.Aa /*Tag: Eliminator2*/;
}

func Eq[a any] (a_ Equal[a], aa a, b a) bool/*Print Function Head*/ {
  return /*Tag: Application Expr*/a_/*Tag: Dict without Classrels*/.Equala(aa, b);
}

func Equal_proda[a, b any] (a_ Equal[a], b_ Equal[b], x0 Prod[a, b], x1 Prod[a, b]) bool/*Print Function Head*/ {
  {
    _ = x0;
    x1b, x2a := Pair_dest(x0);
    _ = x1;
    y1a, y2a := Pair_dest(x1);
    return /*Tag: Application Expr*/Eq[a](a_/*Tag: Dict without Classrels*/, x1b, y1a) && /*Tag: Application Expr*/Eq[b](b_/*Tag: Dict without Classrels*/, x2a, y2a);/*Tag: Pattern Matching2*//*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Equal_prod[a, b any] (a_ Equal[a], b_ Equal[b]) Equal[Prod[a, b]]/*Print Function Head*/ {
  return Equal[Prod[a, b]] {
    Equala: func /*Tag: Anonymous Function*/ (A Prod[a, b], Aa Prod[a, b]) bool/*Print Function Head*/ {
              return /*Tag: Application Expr*/Equal_proda[a, b](a_/*Tag: Dict without Classrels*/, b_/*Tag: Dict without Classrels*/, A, Aa);
            },
  }
}

func Equal_integer () Equal[Bigint.Int]/*Print Function Head*/ {
  return Equal[Bigint.Int] {
    Equala: func /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) bool/*Print Function Head*/ {
              return Bigint.Equal( A, Aa);
            },
  }
}

type Ord[a any] struct {
  Less_eq func(a, a) bool
  Less func(a, a) bool
}

func Ord_integer () Ord[Bigint.Int]/*Print Function Head*/ {
  return Ord[Bigint.Int] {
    Less_eq: func /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) bool/*Print Function Head*/ {
               return Bigint.Less_eq( A, Aa);
             },
    Less: func /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) bool/*Print Function Head*/ {
            return Bigint.Less( A, Aa);
          },
  }
}

type Preorder[a any] struct {
  Ord_preorder Ord[a]
}

type Order[a any] struct {
  Preorder_order Preorder[a]
}

func Preorder_integer () Preorder[Bigint.Int]/*Print Function Head*/ {
  return Preorder[Bigint.Int] {
    Ord_preorder: Ord_integer()/*Tag: Dict without Classrels*/,
  }
}

func Order_integer () Order[Bigint.Int]/*Print Function Head*/ {
  return Order[Bigint.Int] {
    Preorder_order: Preorder_integer()/*Tag: Dict without Classrels*/,
  }
}

type Linorder[a any] struct {
  Order_linorder Order[a]
}

func Linorder_integer () Linorder[Bigint.Int]/*Print Function Head*/ {
  return Linorder[Bigint.Int] {
    Order_linorder: Order_integer()/*Tag: Dict without Classrels*/,
  }
}

// sum type which can be One, Bit0, Bit1
type Num any;
type One struct {
};
type Bit0 struct {
  A Num;
};
type Bit1 struct {
  A Num;
};

func Bit0_dest(p Bit0)(Num) {
  return p.A/*Tag: Eliminator1*/
}
func Bit1_dest(p Bit1)(Num) {
  return p.A/*Tag: Eliminator1*/
}

// sum type which can be Nil, Cons
type List[a any] any;
type Nil[a any] struct {
};
type Cons[a any] struct {
  A a;
  Aa List[a];
};

func Cons_dest[a any](p Cons[a])(a, List[a]) {
  return p.A, p.Aa/*Tag: Eliminator1*/
}

// sum type which can be Leaf, Node
type Tree[a any] any;
type Leaf[a any] struct {
};
type Node[a any] struct {
  A Tree[a];
  Aa a;
  Ab Tree[a];
};

func Node_dest[a any](p Node[a])(Tree[a], a, Tree[a]) {
  return p.A, p.Aa, p.Ab/*Tag: Eliminator1*/
}

// sum type which can be LT, EQ, GT
type Cmp_val any;
type LT struct {
};
type EQ struct {
};
type GT struct {
};




func Cmp[a any] (a1_ Equal[a], a2_ Linorder[a], x a, y a) Cmp_val/*Print Function Head*/ {
  target := /*Tag: Application Expr*/a2_.Order_linorder.Preorder_order.Ord_preorder/*Tag: Dict with Classrels*/.Less(x, y);
  {
    if target == (true) {
      return Cmp_val(/*Tag: Application Expr*/LT{});
    }/*Tag: Pattern Matching1*/
  };
  {
    if target == (false) {
      targeu := /*Tag: Application Expr*/Eq[a](a1_/*Tag: Dict without Classrels*/, x, y);
      {
        if targeu == (true) {
          return Cmp_val(/*Tag: Application Expr*/EQ{});
        }/*Tag: Pattern Matching1*/
      };
      {
        if targeu == (false) {
          return Cmp_val(/*Tag: Application Expr*/GT{});
        }/*Tag: Pattern Matching1*/
      };
      panic("match failed");
    }/*Tag: Pattern Matching1*/
  };
  panic("match failed");
}

func Paint[a any] (c Color, x1 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    if x1 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{});
    }/*Tag: Pattern Matching1*/
  };
  {
    cb := c;
    q, m := x1.(Node[Prod[a, Color]]);
    if m {
      la, p, ra := Node_dest(q);
      _ = p;
      ab, _ := Pair_dest(p);
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{la, /*Tag: Application Expr*/Prod[a, Color]{ab, cb}, ra});/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic("match failed");
}

func BaliR[a any] (t1 Tree[Prod[a, Color]], aa a, x2 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      t2a, q, p := Node_dest(q);
      _ = q;
      ba, d := Pair_dest(q);
      if d == (Color(/*Tag: Application Expr*/Red{})) {
        r, m := p.(Node[Prod[a, Color]]);
        if m {
          t3a, r, t4a := Node_dest(r);
          _ = r;
          ca, e := Pair_dest(r);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, t4a})});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      q, p, d := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        r, m := q.(Node[Prod[a, Color]]);
        if m {
          t2a, r, t3a := Node_dest(r);
          _ = r;
          ba, e := Pair_dest(r);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            _ = p;
            ca, f := Pair_dest(p);
            if f == (Color(/*Tag: Application Expr*/Red{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})})});
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      r, q, p := Node_dest(q);
      s, m := r.(Node[Prod[a, Color]]);
      if m {
        t2a, s, t3a := Node_dest(s);
        _ = s;
        ba, d := Pair_dest(s);
        if d == (Color(/*Tag: Application Expr*/Red{})) {
          _ = q;
          ca, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            t, m := p.(Node[Prod[a, Color]]);
            if m {
              va, t, vba := Node_dest(t);
              _ = t;
              vca, f := Pair_dest(t);
              if f == (Color(/*Tag: Application Expr*/Black{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})})});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
    }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})});
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      d, vaa, c := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) && c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})})});
      }
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      p, vaa, c := Node_dest(q);
      if c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        q, m := p.(Node[Prod[a, Color]]);
        if m {
          vba, q, vda := Node_dest(q);
          _ = q;
          vea, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vba, /*Tag: Application Expr*/Prod[a, Color]{vea, Color(/*Tag: Application Expr*/Black{})}, vda}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})})});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      c, vaa, p := Node_dest(q);
      if c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        q, m := p.(Node[Prod[a, Color]]);
        if m {
          vca, q, vea := Node_dest(q);
          _ = q;
          vfa, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vca, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Black{})}, vea})})});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      q, vaa, p := Node_dest(q);
      r, m := q.(Node[Prod[a, Color]]);
      if m {
        vba, r, vga := Node_dest(r);
        _ = r;
        vha, c := Pair_dest(r);
        if c == (Color(/*Tag: Application Expr*/Black{})) {
          s, m := p.(Node[Prod[a, Color]]);
          if m {
            vca, s, vea := Node_dest(s);
            _ = s;
            vfa, d := Pair_dest(s);
            if d == (Color(/*Tag: Application Expr*/Black{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vba, /*Tag: Application Expr*/Prod[a, Color]{vha, Color(/*Tag: Application Expr*/Black{})}, vga}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vca, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Black{})}, vea})})});
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  panic("match failed");
}

func BaldL[a any] (x0 Tree[Prod[a, Color]], b a, t3 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      t1a, p, t2a := Node_dest(q);
      _ = p;
      ab, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        bb := b;
        t3b := t3;
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{bb, Color(/*Tag: Application Expr*/Red{})}, t3b});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := b;
      q, m := t3.(Node[Prod[a, Color]]);
      if m {
        t2a, p, t3b := Node_dest(q);
        _ = p;
        bb, c := Pair_dest(p);
        if c == (Color(/*Tag: Application Expr*/Black{})) {
          return /*Tag: Application Expr*/BaliR[a](Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), ab, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t2a, /*Tag: Application Expr*/Prod[a, Color]{bb, Color(/*Tag: Application Expr*/Red{})}, t3b}));
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ab := b;
        q, m := t3.(Node[Prod[a, Color]]);
        if m {
          t2a, q, t3b := Node_dest(q);
          _ = q;
          bb, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            return /*Tag: Application Expr*/BaliR[a](Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), ab, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t2a, /*Tag: Application Expr*/Prod[a, Color]{bb, Color(/*Tag: Application Expr*/Red{})}, t3b}));
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := b;
      q, m := t3.(Node[Prod[a, Color]]);
      if m {
        q, p, t4a := Node_dest(q);
        r, m := q.(Node[Prod[a, Color]]);
        if m {
          t2a, r, t3b := Node_dest(r);
          _ = r;
          bb, d := Pair_dest(r);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            _ = p;
            ca, e := Pair_dest(p);
            if e == (Color(/*Tag: Application Expr*/Red{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{bb, Color(/*Tag: Application Expr*/Red{})}, /*Tag: Application Expr*/BaliR[a](t3b, ca, /*Tag: Application Expr*/Paint[a](Color(/*Tag: Application Expr*/Red{}), t4a))});
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, d := Pair_dest(p);
      if d == (Color(/*Tag: Application Expr*/Black{})) {
        ab := b;
        q, m := t3.(Node[Prod[a, Color]]);
        if m {
          r, q, t4a := Node_dest(q);
          s, m := r.(Node[Prod[a, Color]]);
          if m {
            t2a, s, t3b := Node_dest(s);
            _ = s;
            bb, e := Pair_dest(s);
            if e == (Color(/*Tag: Application Expr*/Black{})) {
              _ = q;
              ca, f := Pair_dest(q);
              if f == (Color(/*Tag: Application Expr*/Red{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{bb, Color(/*Tag: Application Expr*/Red{})}, /*Tag: Application Expr*/BaliR[a](t3b, ca, /*Tag: Application Expr*/Paint[a](Color(/*Tag: Application Expr*/Red{}), t4a))});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := b;
      if t3 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
      }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := b;
      q, m := t3.(Node[Prod[a, Color]]);
      if m {
        c, p, vba := Node_dest(q);
        if c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
          _ = p;
          vca, d := Pair_dest(p);
          if d == (Color(/*Tag: Application Expr*/Red{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Red{})}, vba})});
          }/*Tag: Pattern Matching2*/
        }
      }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := b;
      q, m := t3.(Node[Prod[a, Color]]);
      if m {
        q, p, vba := Node_dest(q);
        r, m := q.(Node[Prod[a, Color]]);
        if m {
          vaa, r, vea := Node_dest(r);
          _ = r;
          vfa, c := Pair_dest(r);
          if c == (Color(/*Tag: Application Expr*/Red{})) {
            _ = p;
            vca, d := Pair_dest(p);
            if d == (Color(/*Tag: Application Expr*/Red{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vaa, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, vea}), /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Red{})}, vba})});
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ab := b;
        if t3 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
          return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
        }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ab := b;
        q, m := t3.(Node[Prod[a, Color]]);
        if m {
          d, q, vea := Node_dest(q);
          if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
            _ = q;
            vfa, e := Pair_dest(q);
            if e == (Color(/*Tag: Application Expr*/Red{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, vea})});
            }/*Tag: Pattern Matching2*/
          }
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ab := b;
        q, m := t3.(Node[Prod[a, Color]]);
        if m {
          r, q, vea := Node_dest(q);
          s, m := r.(Node[Prod[a, Color]]);
          if m {
            vda, s, vha := Node_dest(s);
            _ = s;
            via, d := Pair_dest(s);
            if d == (Color(/*Tag: Application Expr*/Red{})) {
              _ = q;
              vfa, e := Pair_dest(q);
              if e == (Color(/*Tag: Application Expr*/Red{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vda, /*Tag: Application Expr*/Prod[a, Color]{via, Color(/*Tag: Application Expr*/Red{})}, vha}), /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, vea})});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Join[a any] (x0 Tree[Prod[a, Color]], t Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      tb := t;
      return tb;/*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      vc, vaa, vba := Node_dest(q);
      if t == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vc, vaa, vba});
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      t1a, p, t2a := Node_dest(q);
      _ = p;
      ab, d := Pair_dest(p);
      if d == (Color(/*Tag: Application Expr*/Red{})) {
        q, m := t.(Node[Prod[a, Color]]);
        if m {
          t3a, q, t4a := Node_dest(q);
          _ = q;
          ca, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            target := /*Tag: Application Expr*/Join[a](t2a, t3a);
            {
              if target == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Red{})}, t4a})});
              }/*Tag: Pattern Matching1*/
            };
            {
              r, m := target.(Node[Prod[a, Color]]);
              if m {
                u2, r, u3 := Node_dest(r);
                _ = r;
                b, f := Pair_dest(r);
                if f == (Color(/*Tag: Application Expr*/Red{})) {
                  return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, u2}), /*Tag: Application Expr*/Prod[a, Color]{b, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{u3, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Red{})}, t4a})});
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            {
              r, m := target.(Node[Prod[a, Color]]);
              if m {
                u2, r, u3 := Node_dest(r);
                _ = r;
                b, f := Pair_dest(r);
                if f == (Color(/*Tag: Application Expr*/Black{})) {
                  return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{u2, /*Tag: Application Expr*/Prod[a, Color]{b, Color(/*Tag: Application Expr*/Black{})}, u3}), /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Red{})}, t4a})});
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            panic("match failed");
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      t1a, p, t2a := Node_dest(q);
      _ = p;
      ab, d := Pair_dest(p);
      if d == (Color(/*Tag: Application Expr*/Black{})) {
        q, m := t.(Node[Prod[a, Color]]);
        if m {
          t3a, q, t4a := Node_dest(q);
          _ = q;
          ca, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            target := /*Tag: Application Expr*/Join[a](t2a, t3a);
            {
              if target == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
                return /*Tag: Application Expr*/BaldL[a](t1a, ab, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, t4a}));
              }/*Tag: Pattern Matching1*/
            };
            {
              r, m := target.(Node[Prod[a, Color]]);
              if m {
                u2, r, u3 := Node_dest(r);
                _ = r;
                b, f := Pair_dest(r);
                if f == (Color(/*Tag: Application Expr*/Red{})) {
                  return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, u2}), /*Tag: Application Expr*/Prod[a, Color]{b, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{u3, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, t4a})});
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            {
              r, m := target.(Node[Prod[a, Color]]);
              if m {
                u2, r, u3 := Node_dest(r);
                _ = r;
                b, f := Pair_dest(r);
                if f == (Color(/*Tag: Application Expr*/Black{})) {
                  return /*Tag: Application Expr*/BaldL[a](t1a, ab, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{u2, /*Tag: Application Expr*/Prod[a, Color]{b, Color(/*Tag: Application Expr*/Black{})}, u3}), /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, t4a}));
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            panic("match failed");
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        q, m := t.(Node[Prod[a, Color]]);
        if m {
          t2a, q, t3a := Node_dest(q);
          _ = q;
          ab, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Red{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{/*Tag: Application Expr*/Join[a](Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), t2a), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, t3a});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      t1a, p, t2a := Node_dest(q);
      _ = p;
      ab, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        q, m := t.(Node[Prod[a, Color]]);
        if m {
          va, q, vba := Node_dest(q);
          _ = q;
          vca, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, /*Tag: Application Expr*/Join[a](t2a, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}))});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Fold[a, b any] (f func(a) func(b) b, x1 List[a], s b) b/*Print Function Head*/ {
  {
    fb := f;
    q, m := x1.(Cons[a]);
    if m {
      xa, xsa := Cons_dest(q);
      sb := s;
      return /*Tag: Application Expr*/Fold[a, b](fb, xsa, ((fb(xa))(sb)));/*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  {
    if x1 == (List[a](/*Tag: Application Expr*/Nil[a]{})) {
      sb := s;
      return sb;/*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  panic("match failed");
}

func BaliL[a any] (x0 Tree[Prod[a, Color]], c a, t4 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      q, p, t3a := Node_dest(q);
      r, m := q.(Node[Prod[a, Color]]);
      if m {
        t1a, r, t2a := Node_dest(r);
        _ = r;
        ab, d := Pair_dest(r);
        if d == (Color(/*Tag: Application Expr*/Red{})) {
          _ = p;
          ba, e := Pair_dest(p);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            cb := c;
            t4b := t4;
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1a, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{cb, Color(/*Tag: Application Expr*/Black{})}, t4b})});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      d, q, p := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        _ = q;
        ab, e := Pair_dest(q);
        if e == (Color(/*Tag: Application Expr*/Red{})) {
          r, m := p.(Node[Prod[a, Color]]);
          if m {
            t2a, r, t3a := Node_dest(r);
            _ = r;
            ba, f := Pair_dest(r);
            if f == (Color(/*Tag: Application Expr*/Red{})) {
              cb := c;
              t4b := t4;
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{cb, Color(/*Tag: Application Expr*/Black{})}, t4b})});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      r, q, p := Node_dest(q);
      s, m := r.(Node[Prod[a, Color]]);
      if m {
        va, s, vba := Node_dest(s);
        _ = s;
        vca, d := Pair_dest(s);
        if d == (Color(/*Tag: Application Expr*/Black{})) {
          _ = q;
          ab, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Red{})) {
            t, m := p.(Node[Prod[a, Color]]);
            if m {
              t2a, t, t3a := Node_dest(t);
              _ = t;
              ba, f := Pair_dest(t);
              if f == (Color(/*Tag: Application Expr*/Red{})) {
                cb := c;
                t4b := t4;
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a}), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{cb, Color(/*Tag: Application Expr*/Black{})}, t4b})});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ab := c;
      t2a := t4;
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      d, p, vba := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        _ = p;
        va, e := Pair_dest(p);
        if e == (Color(/*Tag: Application Expr*/Black{})) {
          ab := c;
          t2a := t4;
          return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{va, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      e, vaa, d := Node_dest(q);
      if e == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) && d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        ab := c;
        t2a := t4;
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      d, vaa, p := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        q, m := p.(Node[Prod[a, Color]]);
        if m {
          vb, q, vda := Node_dest(q);
          _ = q;
          vea, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            ab := c;
            t2a := t4;
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vb, /*Tag: Application Expr*/Prod[a, Color]{vea, Color(/*Tag: Application Expr*/Black{})}, vda})}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      q, p, vba := Node_dest(q);
      r, m := q.(Node[Prod[a, Color]]);
      if m {
        vca, r, vea := Node_dest(r);
        _ = r;
        vfa, d := Pair_dest(r);
        if d == (Color(/*Tag: Application Expr*/Black{})) {
          _ = p;
          va, e := Pair_dest(p);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            ab := c;
            t2a := t4;
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vca, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Black{})}, vea}), /*Tag: Application Expr*/Prod[a, Color]{va, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      p, vaa, d := Node_dest(q);
      if d == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        q, m := p.(Node[Prod[a, Color]]);
        if m {
          vca, q, vea := Node_dest(q);
          _ = q;
          vfa, e := Pair_dest(q);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            ab := c;
            t2a := t4;
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vca, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Black{})}, vea}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      q, vaa, p := Node_dest(q);
      r, m := q.(Node[Prod[a, Color]]);
      if m {
        vca, r, vea := Node_dest(r);
        _ = r;
        vfa, d := Pair_dest(r);
        if d == (Color(/*Tag: Application Expr*/Black{})) {
          s, m := p.(Node[Prod[a, Color]]);
          if m {
            vb, s, vga := Node_dest(s);
            _ = s;
            vha, e := Pair_dest(s);
            if e == (Color(/*Tag: Application Expr*/Black{})) {
              ab := c;
              t2a := t4;
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vca, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Black{})}, vea}), vaa, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vb, /*Tag: Application Expr*/Prod[a, Color]{vha, Color(/*Tag: Application Expr*/Black{})}, vga})}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      va, p, vba := Node_dest(q);
      _ = p;
      vca, d := Pair_dest(p);
      if d == (Color(/*Tag: Application Expr*/Black{})) {
        ab := c;
        t2a := t4;
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, t2a});/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func BaldR[a any] (t1 Tree[Prod[a, Color]], aa a, x2 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    t1b := t1;
    ac := aa;
    q, m := x2.(Node[Prod[a, Color]]);
    if m {
      t2a, p, t3a := Node_dest(q);
      _ = p;
      ba, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t2a, /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Black{})}, t3a})});
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      t1b, p, t2a := Node_dest(q);
      _ = p;
      ac, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ba := aa;
        if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
          return /*Tag: Application Expr*/BaliL[a](Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, t2a}), ba, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}));
        }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      t1b, p, t2a := Node_dest(q);
      _ = p;
      ac, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        ba := aa;
        q, m := x2.(Node[Prod[a, Color]]);
        if m {
          va, q, vba := Node_dest(q);
          _ = q;
          vca, d := Pair_dest(q);
          if d == (Color(/*Tag: Application Expr*/Black{})) {
            return /*Tag: Application Expr*/BaliL[a](Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t1b, /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, t2a}), ba, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba}));
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      t1b, q, p := Node_dest(q);
      _ = q;
      ac, d := Pair_dest(q);
      if d == (Color(/*Tag: Application Expr*/Red{})) {
        r, m := p.(Node[Prod[a, Color]]);
        if m {
          t2a, r, t3a := Node_dest(r);
          _ = r;
          ba, e := Pair_dest(r);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            ca := aa;
            if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{/*Tag: Application Expr*/BaliL[a](/*Tag: Application Expr*/Paint[a](Color(/*Tag: Application Expr*/Red{}), t1b), ac, t2a), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})})});
            }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      t1b, q, p := Node_dest(q);
      _ = q;
      ac, d := Pair_dest(q);
      if d == (Color(/*Tag: Application Expr*/Red{})) {
        r, m := p.(Node[Prod[a, Color]]);
        if m {
          t2a, r, t3a := Node_dest(r);
          _ = r;
          ba, e := Pair_dest(r);
          if e == (Color(/*Tag: Application Expr*/Black{})) {
            ca := aa;
            s, m := x2.(Node[Prod[a, Color]]);
            if m {
              va, s, vba := Node_dest(s);
              _ = s;
              vca, f := Pair_dest(s);
              if f == (Color(/*Tag: Application Expr*/Black{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{/*Tag: Application Expr*/BaliL[a](/*Tag: Application Expr*/Paint[a](Color(/*Tag: Application Expr*/Red{}), t1b), ac, t2a), /*Tag: Application Expr*/Prod[a, Color]{ba, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{t3a, /*Tag: Application Expr*/Prod[a, Color]{ca, Color(/*Tag: Application Expr*/Black{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})})});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if t1 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ac := aa;
      if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
      }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      va, p, c := Node_dest(q);
      if c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        _ = p;
        vca, d := Pair_dest(p);
        if d == (Color(/*Tag: Application Expr*/Red{})) {
          ac := aa;
          if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
          }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      vb, q, p := Node_dest(q);
      _ = q;
      vca, c := Pair_dest(q);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        r, m := p.(Node[Prod[a, Color]]);
        if m {
          vaa, r, vea := Node_dest(r);
          _ = r;
          vfa, d := Pair_dest(r);
          if d == (Color(/*Tag: Application Expr*/Red{})) {
            ac := aa;
            if x2 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vb, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vaa, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, vea})}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
            }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if t1 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      ac := aa;
      q, m := x2.(Node[Prod[a, Color]]);
      if m {
        va, p, vba := Node_dest(q);
        _ = p;
        vca, c := Pair_dest(p);
        if c == (Color(/*Tag: Application Expr*/Black{})) {
          return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{va, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})});
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      vaa, p, c := Node_dest(q);
      if c == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
        _ = p;
        vfa, d := Pair_dest(p);
        if d == (Color(/*Tag: Application Expr*/Red{})) {
          ac := aa;
          q, m := x2.(Node[Prod[a, Color]]);
          if m {
            vd, q, vba := Node_dest(q);
            _ = q;
            vca, e := Pair_dest(q);
            if e == (Color(/*Tag: Application Expr*/Black{})) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vaa, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vd, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})});
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
        }/*Tag: Pattern Matching2*/
      }
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := t1.(Node[Prod[a, Color]]);
    if m {
      vaa, q, p := Node_dest(q);
      _ = q;
      vfa, c := Pair_dest(q);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        r, m := p.(Node[Prod[a, Color]]);
        if m {
          vda, r, vha := Node_dest(r);
          _ = r;
          via, d := Pair_dest(r);
          if d == (Color(/*Tag: Application Expr*/Red{})) {
            ac := aa;
            s, m := x2.(Node[Prod[a, Color]]);
            if m {
              ve, s, vba := Node_dest(s);
              _ = s;
              vca, e := Pair_dest(s);
              if e == (Color(/*Tag: Application Expr*/Black{})) {
                return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vaa, /*Tag: Application Expr*/Prod[a, Color]{vfa, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{vda, /*Tag: Application Expr*/Prod[a, Color]{via, Color(/*Tag: Application Expr*/Red{})}, vha})}), /*Tag: Application Expr*/Prod[a, Color]{ac, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{ve, /*Tag: Application Expr*/Prod[a, Color]{vca, Color(/*Tag: Application Expr*/Black{})}, vba})});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Equal_tree[a any] (a_ Equal[a], x0 Tree[a], x1 Tree[a]) bool/*Print Function Head*/ {
  {
    if x0 == (Tree[a](/*Tag: Application Expr*/Leaf[a]{})) {
      _, m := x1.(Node[a]);
      if m {
        return false;
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching1*/
  };
  {
    _, m := x0.(Node[a]);
    if m {
      if x1 == (Tree[a](/*Tag: Application Expr*/Leaf[a]{})) {
        return false;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching2*/
  };
  {
    q, m := x0.(Node[a]);
    if m {
      x21a, x22a, x23a := Node_dest(q);
      q, m := x1.(Node[a]);
      if m {
        y21a, y22a, y23a := Node_dest(q);
        return /*Tag: Application Expr*/Equal_tree[a](a_/*Tag: Dict without Classrels*/, x21a, y21a) && (/*Tag: Application Expr*/Eq[a](a_/*Tag: Dict without Classrels*/, x22a, y22a) && /*Tag: Application Expr*/Equal_tree[a](a_/*Tag: Dict without Classrels*/, x23a, y23a));
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    if x0 == (Tree[a](/*Tag: Application Expr*/Leaf[a]{})) {
      if x1 == (Tree[a](/*Tag: Application Expr*/Leaf[a]{})) {
        return true;
      }/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching1*/
  };
  panic("match failed");
}

func Colora[a any] (x0 Tree[Prod[a, Color]]) Color/*Print Function Head*/ {
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return Color(/*Tag: Application Expr*/Black{});
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      _, p, _ := Node_dest(q);
      _ = p;
      _, ca := Pair_dest(p);
      return ca;/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Del[a any] (a1_ Equal[a], a2_ Linorder[a], x a, xa1 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    if xa1 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{});
    }/*Tag: Pattern Matching1*/
  };
  {
    xb := x;
    q, m := xa1.(Node[Prod[a, Color]]);
    if m {
      la, p, ra := Node_dest(q);
      _ = p;
      ab, _ := Pair_dest(p);
      target := /*Tag: Application Expr*/Cmp[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
      {
        if target == (Cmp_val(/*Tag: Application Expr*/LT{})) {
          targeu := ! /*Tag: Application Expr*/Equal_tree[Prod[a, Color]](Equal_prod[a, Color](a1_/*Tag: Dict without Classrels*/, Equal_color()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, la, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) && /*Tag: Application Expr*/Equal_colora(/*Tag: Application Expr*/Colora[a](la), Color(/*Tag: Application Expr*/Black{}));
          {
            if targeu == (true) {
              return /*Tag: Application Expr*/BaldL[a](/*Tag: Application Expr*/Del[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), ab, ra);
            }/*Tag: Pattern Matching1*/
          };
          {
            if targeu == (false) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{/*Tag: Application Expr*/Del[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, ra});
            }/*Tag: Pattern Matching1*/
          };
          panic("match failed");
        }/*Tag: Pattern Matching1*/
      };
      {
        if target == (Cmp_val(/*Tag: Application Expr*/EQ{})) {
          return /*Tag: Application Expr*/Join[a](la, ra);
        }/*Tag: Pattern Matching1*/
      };
      {
        if target == (Cmp_val(/*Tag: Application Expr*/GT{})) {
          targeu := ! /*Tag: Application Expr*/Equal_tree[Prod[a, Color]](Equal_prod[a, Color](a1_/*Tag: Dict without Classrels*/, Equal_color()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, ra, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) && /*Tag: Application Expr*/Equal_colora(/*Tag: Application Expr*/Colora[a](ra), Color(/*Tag: Application Expr*/Black{}));
          {
            if targeu == (true) {
              return /*Tag: Application Expr*/BaldR[a](la, ab, /*Tag: Application Expr*/Del[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra));
            }/*Tag: Pattern Matching1*/
          };
          {
            if targeu == (false) {
              return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{la, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, /*Tag: Application Expr*/Del[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra)});
            }/*Tag: Pattern Matching1*/
          };
          panic("match failed");
        }/*Tag: Pattern Matching1*/
      };
      panic("match failed");/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic("match failed");
}

func Ins[a any] (a1_ Equal[a], a2_ Linorder[a], x a, xa1 Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  {
    xb := x;
    if xa1 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{}), /*Tag: Application Expr*/Prod[a, Color]{xb, Color(/*Tag: Application Expr*/Red{})}, Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})});
    }/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
  };
  {
    xb := x;
    q, m := xa1.(Node[Prod[a, Color]]);
    if m {
      la, p, ra := Node_dest(q);
      _ = p;
      ab, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Black{})) {
        target := /*Tag: Application Expr*/Cmp[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
        {
          if target == (Cmp_val(/*Tag: Application Expr*/LT{})) {
            return /*Tag: Application Expr*/BaliL[a](/*Tag: Application Expr*/Ins[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), ab, ra);
          }/*Tag: Pattern Matching1*/
        };
        {
          if target == (Cmp_val(/*Tag: Application Expr*/EQ{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{la, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Black{})}, ra});
          }/*Tag: Pattern Matching1*/
        };
        {
          if target == (Cmp_val(/*Tag: Application Expr*/GT{})) {
            return /*Tag: Application Expr*/BaliR[a](la, ab, /*Tag: Application Expr*/Ins[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra));
          }/*Tag: Pattern Matching1*/
        };
        panic("match failed");
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  {
    xb := x;
    q, m := xa1.(Node[Prod[a, Color]]);
    if m {
      la, p, ra := Node_dest(q);
      _ = p;
      ab, c := Pair_dest(p);
      if c == (Color(/*Tag: Application Expr*/Red{})) {
        target := /*Tag: Application Expr*/Cmp[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
        {
          if target == (Cmp_val(/*Tag: Application Expr*/LT{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{/*Tag: Application Expr*/Ins[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, ra});
          }/*Tag: Pattern Matching1*/
        };
        {
          if target == (Cmp_val(/*Tag: Application Expr*/EQ{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{la, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, ra});
          }/*Tag: Pattern Matching1*/
        };
        {
          if target == (Cmp_val(/*Tag: Application Expr*/GT{})) {
            return Tree[Prod[a, Color]](/*Tag: Application Expr*/Node[Prod[a, Color]]{la, /*Tag: Application Expr*/Prod[a, Color]{ab, Color(/*Tag: Application Expr*/Red{})}, /*Tag: Application Expr*/Ins[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra)});
          }/*Tag: Pattern Matching1*/
        };
        panic("match failed");
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic("match failed");
}

func Insert[a any] (a1_ Equal[a], a2_ Linorder[a], x a, t Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  return /*Tag: Application Expr*/Paint[a](Color(/*Tag: Application Expr*/Black{}), /*Tag: Application Expr*/Ins[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, x, t));
}

func Empty[a any] () Tree[Prod[a, Color]]/*Print Function Head*/ {
  return Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{});
}

func T1 () Tree[Prod[Bigint.Int, Color]]/*Print Function Head*/ {
  return /*Tag: Application Expr*/Fold[Bigint.Int, Tree[Prod[Bigint.Int, Color]]](func /*Tag: Anonymous Function*/ (a Bigint.Int) func(Tree[Prod[Bigint.Int, Color]]) Tree[Prod[Bigint.Int, Color]]/*Print Function Head*/ {
    return func /*Tag: Anonymous Function*/ (b Tree[Prod[Bigint.Int, Color]]) Tree[Prod[Bigint.Int, Color]]/*Print Function Head*/ {
             return /*Tag: Application Expr*/Insert[Bigint.Int](Equal_integer()/*Tag: Dict without Classrels*/, Linorder_integer()/*Tag: Dict without Classrels*/, a, b);
           };
  }, List[Bigint.Int](/*Tag: Application Expr*/Cons[Bigint.Int]{Bigint.MkInt("1"), List[Bigint.Int](/*Tag: Application Expr*/Cons[Bigint.Int]{Bigint.MkInt("2"), List[Bigint.Int](/*Tag: Application Expr*/Cons[Bigint.Int]{Bigint.MkInt("3"), List[Bigint.Int](/*Tag: Application Expr*/Cons[Bigint.Int]{Bigint.MkInt("4"), List[Bigint.Int](/*Tag: Application Expr*/Cons[Bigint.Int]{Bigint.MkInt("5"), List[Bigint.Int](/*Tag: Application Expr*/Nil[Bigint.Int]{})})})})})}), /*Tag: Application Expr*/Empty[Bigint.Int]());
}

func Invc[a any] (x0 Tree[Prod[a, Color]]) bool/*Print Function Head*/ {
  {
    if x0 == (Tree[Prod[a, Color]](/*Tag: Application Expr*/Leaf[Prod[a, Color]]{})) {
      return true;
    }/*Tag: Pattern Matching1*/
  };
  {
    q, m := x0.(Node[Prod[a, Color]]);
    if m {
      la, p, ra := Node_dest(q);
      _ = p;
      _, ca := Pair_dest(p);
      return (!(/*Tag: Application Expr*/Equal_colora(ca, Color(/*Tag: Application Expr*/Red{}))) || /*Tag: Application Expr*/Equal_colora(/*Tag: Application Expr*/Colora[a](la), Color(/*Tag: Application Expr*/Black{})) && /*Tag: Application Expr*/Equal_colora(/*Tag: Application Expr*/Colora[a](ra), Color(/*Tag: Application Expr*/Black{}))) && (/*Tag: Application Expr*/Invc[a](la) && /*Tag: Application Expr*/Invc[a](ra));/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic("match failed");
}

func Delete_list[a any] (a1_ Equal[a], a2_ Linorder[a], xs List[a], aa Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  return /*Tag: Application Expr*/Fold[a, Tree[Prod[a, Color]]](func /*Tag: Anonymous Function*/ (ab a) func(Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
                          return func /*Tag: Anonymous Function*/ (b Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
                                   return /*Tag: Application Expr*/Del[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, ab, b);
                                 };
                        }, xs, aa);
}

func Trees_equal[a any] (a_ Equal[a], aa Tree[Prod[a, Color]], b Tree[Prod[a, Color]]) bool/*Print Function Head*/ {
  return /*Tag: Application Expr*/Equal_tree[Prod[a, Color]](Equal_prod[a, Color](a_/*Tag: Dict without Classrels*/, Equal_color()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, aa, b);
}

func Tree_from_list[a any] (a1_ Equal[a], a2_ Linorder[a], xs List[a]) Tree[Prod[a, Color]]/*Print Function Head*/ {
  return /*Tag: Application Expr*/Fold[a, Tree[Prod[a, Color]]](func /*Tag: Anonymous Function*/ (aa a) func(Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
                          return func /*Tag: Anonymous Function*/ (b Tree[Prod[a, Color]]) Tree[Prod[a, Color]]/*Print Function Head*/ {
                                   return /*Tag: Application Expr*/Insert[a](a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, aa, b);
                                 };
                        }, xs, /*Tag: Application Expr*/Empty[a]());
}
