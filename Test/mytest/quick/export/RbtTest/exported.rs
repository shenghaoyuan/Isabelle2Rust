package RbtTest

import (
  "isabelle/exported/Bigint"
)

// enum type which can be Red, Black
enum Color {
  Red{},
  Black{},
}

fn equal_color (x0 : Color, x1 : Color) -> bool {
  {
    Color::Red{} => Color::Black{} => return false;/*Tag: Pattern Matching1*//*Tag: Pattern Matching1*/
  };
  {
    Color::Black{} => Color::Red{} => return false;/*Tag: Pattern Matching1*//*Tag: Pattern Matching1*/
  };
  {
    Color::Black{} => Color::Black{} => return true;/*Tag: Pattern Matching1*//*Tag: Pattern Matching1*/
  };
  {
    Color::Red{} => Color::Red{} => return true;/*Tag: Pattern Matching1*//*Tag: Pattern Matching1*/
  };
  panic!("match failed");
}

type Equal<a> struct {
  Equala fn(a, a)  ->  bool
}

fn EqualColor () -> Equal<Color> {
  return Equal<Color> {
    Equala: fn /*Tag: Anonymous Function*/ (A Color, Aa Color) -> bool {
              return equal_color(A, Aa);
            },
  }
}

Prod<a, b>{A: a,Aa: b,},

fn eq<a> (a_ Equal<a>, aa : a, b : a) -> bool {
  return a_/*Tag: Dict without Classrels*/.Equala(aa, b);
}

fn equal_prod<a, b> (a_ Equal<a>, b_ Equal<b>, x0 : Prod<a, b>, x1 : Prod<a, b>) -> bool {
  {
    x0
    => {
      x1
      => {
        return eq<a>(a_/*Tag: Dict without Classrels*/, x1b, y1a) && eq<b>(b_/*Tag: Dict without Classrels*/, x2a, y2a);
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn EqualProd<a, b> (a_ Equal<a>, b_ Equal<b>) -> Equal<Prod<a, b>> {
  return Equal<Prod<a, b>> {
    Equala: fn /*Tag: Anonymous Function*/ (A Prod<a, b>, Aa Prod<a, b>) -> bool {
              return equal_prod<a, b>(a_/*Tag: Dict without Classrels*/, b_/*Tag: Dict without Classrels*/, A, Aa);
            },
  }
}

fn EqualInteger () -> Equal<Bigint.Int> {
  return Equal<Bigint.Int> {
    Equala: fn /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) -> bool {
              return Bigint.Equal( A, Aa);
            },
  }
}

type Ord<a> struct {
  LessEq fn(a, a)  ->  bool
  Less fn(a, a)  ->  bool
}

fn OrdInteger () -> Ord<Bigint.Int> {
  return Ord<Bigint.Int> {
    LessEq: fn /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) -> bool {
              return Bigint.Less_eq( A, Aa);
            },
    Less: fn /*Tag: Anonymous Function*/ (A Bigint.Int, Aa Bigint.Int) -> bool {
            return Bigint.Less( A, Aa);
          },
  }
}

type Preorder<a> struct {
  OrdPreorder Ord<a>
}

type Order<a> struct {
  PreorderOrder Preorder<a>
}

fn PreorderInteger () -> Preorder<Bigint.Int> {
  return Preorder<Bigint.Int> {
    OrdPreorder: OrdInteger()/*Tag: Dict without Classrels*/,
  }
}

fn OrderInteger () -> Order<Bigint.Int> {
  return Order<Bigint.Int> {
    PreorderOrder: PreorderInteger()/*Tag: Dict without Classrels*/,
  }
}

type Linorder<a> struct {
  OrderLinorder Order<a>
}

fn LinorderInteger () -> Linorder<Bigint.Int> {
  return Linorder<Bigint.Int> {
    OrderLinorder: OrderInteger()/*Tag: Dict without Classrels*/,
  }
}

// enum type which can be One, Bit0, Bit1
enum Num {
  One{},
  Bit0{A: Num,},
  Bit1{A: Num,},
}

// enum type which can be Nil, Cons
enum List<a> {
  Nil<a>{},
  Cons<a>{A: a,Aa: List<a>,},
}

// enum type which can be Leaf, Node
enum Tree<a> {
  Leaf<a>{},
  Node<a>{A: Tree<a>,Aa: a,Ab: Tree<a>,},
}

// enum type which can be LT, EQ, GT
enum CmpVal {
  LT{},
  EQ{},
  GT{},
}

fn cmp<a> (a1_ Equal<a>, a2_ Linorder<a>, x : a, y : a) -> CmpVal {
  target := a2_.OrderLinorder.PreorderOrder.OrdPreorder/*Tag: Dict with Classrels*/.Less(x, y);
  {
    true => return CmpVal::LT{};/*Tag: Pattern Matching1*/
  };
  {
    false => targeu := eq<a>(a1_/*Tag: Dict without Classrels*/, x, y);
             {
               true => return CmpVal::EQ{};/*Tag: Pattern Matching1*/
             };
             {
               false => return CmpVal::GT{};/*Tag: Pattern Matching1*/
             };
             panic!("match failed");/*Tag: Pattern Matching1*/
  };
  panic!("match failed");
}

fn paint<a> (c : Color, x1 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{};/*Tag: Pattern Matching1*/
  };
  {
    cb := c;
    x1.(Node<Prod<a, Color>>)
    => {
      p
      => {
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{la, Prod<a, Color>{ab, cb}, ra};
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic!("match failed");
}

fn balir<a> (t1 : Tree<Prod<a, Color>>, aa : a, x2 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    => {
      q
      if/**/ d == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ e == (Color::Red{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{ca, Color::Black{}}, t4a}};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      q.(Node<Prod<a, Color>>)
      => {
        r
        if/**/ e == (Color::Red{}) => {
          p
          if/**/ f == (Color::Red{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{ca, Color::Black{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    => {
      r.(Node<Prod<a, Color>>)
      => {
        s
        if/**/ d == (Color::Red{}) => {
          q
          if/**/ e == (Color::Red{}) => {
            p.(Node<Prod<a, Color>>)
            => {
              t
              if/**/ f == (Color::Black{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{ca, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}}};
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
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}};
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) && c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, vaa, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}};
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    if/**/ c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p.(Node<Prod<a, Color>>)
      => {
        q
        if/**/ d == (Color::Black{}) => {
          return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vba, Prod<a, Color>{vea, Color::Black{}}, vda}, vaa, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}};
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    if/**/ c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p.(Node<Prod<a, Color>>)
      => {
        q
        if/**/ d == (Color::Black{}) => {
          return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, vaa, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vca, Prod<a, Color>{vfa, Color::Black{}}, vea}}};
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    => {
      q.(Node<Prod<a, Color>>)
      => {
        r
        if/**/ c == (Color::Black{}) => {
          p.(Node<Prod<a, Color>>)
          => {
            s
            if/**/ d == (Color::Black{}) => {
              return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vba, Prod<a, Color>{vha, Color::Black{}}, vga}, vaa, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vca, Prod<a, Color>{vfa, Color::Black{}}, vea}}};
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  panic!("match failed");
}

fn baldl<a> (x0 : Tree<Prod<a, Color>>, b : a, t3 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Red{}) => {
        bb := b;
        t3b := t3;
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{bb, Color::Red{}}, t3b};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := b;
            t3.(Node<Prod<a, Color>>)
            => {
              p
              if/**/ c == (Color::Black{}) => {
                return balir<a>(Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, ab, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t2a, Prod<a, Color>{bb, Color::Red{}}, t3b});
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ab := b;
        t3.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ d == (Color::Black{}) => {
            return balir<a>(Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, ab, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t2a, Prod<a, Color>{bb, Color::Red{}}, t3b});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := b;
            t3.(Node<Prod<a, Color>>)
            => {
              q.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ d == (Color::Black{}) => {
                  p
                  if/**/ e == (Color::Red{}) => {
                    return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{bb, Color::Red{}}, balir<a>(t3b, ca, paint<a>(Color::Red{}, t4a))};
                  }/*Tag: Pattern Matching2*/
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ d == (Color::Black{}) => {
        ab := b;
        t3.(Node<Prod<a, Color>>)
        => {
          r.(Node<Prod<a, Color>>)
          => {
            s
            if/**/ e == (Color::Black{}) => {
              q
              if/**/ f == (Color::Red{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{bb, Color::Red{}}, balir<a>(t3b, ca, paint<a>(Color::Red{}, t4a))};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := b;
            Tree<Prod<a, Color>>::Leaf<Prod<a,
     Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := b;
            t3.(Node<Prod<a, Color>>)
            if/**/ c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
              p
              if/**/ d == (Color::Red{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{vca, Color::Red{}}, vba}};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := b;
            t3.(Node<Prod<a, Color>>)
            => {
              q.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ c == (Color::Red{}) => {
                  p
                  if/**/ d == (Color::Red{}) => {
                    return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vaa, Prod<a, Color>{vfa, Color::Red{}}, vea}, Prod<a, Color>{vca, Color::Red{}}, vba}};
                  }/*Tag: Pattern Matching2*/
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ab := b;
        Tree<Prod<a, Color>>::Leaf<Prod<a,
 Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ab := b;
        t3.(Node<Prod<a, Color>>)
        if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
          q
          if/**/ e == (Color::Red{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{vfa, Color::Red{}}, vea}};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ab := b;
        t3.(Node<Prod<a, Color>>)
        => {
          r.(Node<Prod<a, Color>>)
          => {
            s
            if/**/ d == (Color::Red{}) => {
              q
              if/**/ e == (Color::Red{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vda, Prod<a, Color>{via, Color::Red{}}, vha}, Prod<a, Color>{vfa, Color::Red{}}, vea}};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn join<a> (x0 : Tree<Prod<a, Color>>, t : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => tb := t;
            return tb;/*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vc, vaa, vba};/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ d == (Color::Red{}) => {
        t.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ e == (Color::Red{}) => {
            target := join<a>(t2a, t3a);
            {
              Tree<Prod<a, Color>>::Leaf<Prod<a,
       Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ca, Color::Red{}}, t4a}};/*Tag: Pattern Matching1*/
            };
            {
              target.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ f == (Color::Red{}) => {
                  return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Red{}}, u2}, Prod<a, Color>{b, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{u3, Prod<a, Color>{ca, Color::Red{}}, t4a}};
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            {
              target.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ f == (Color::Black{}) => {
                  return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{u2, Prod<a, Color>{b, Color::Black{}}, u3}, Prod<a, Color>{ca, Color::Red{}}, t4a}};
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            panic!("match failed");
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ d == (Color::Black{}) => {
        t.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ e == (Color::Black{}) => {
            target := join<a>(t2a, t3a);
            {
              Tree<Prod<a, Color>>::Leaf<Prod<a,
       Color>>{} => return baldl<a>(t1a, ab, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ca, Color::Black{}}, t4a});/*Tag: Pattern Matching1*/
            };
            {
              target.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ f == (Color::Red{}) => {
                  return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Black{}}, u2}, Prod<a, Color>{b, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{u3, Prod<a, Color>{ca, Color::Black{}}, t4a}};
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            {
              target.(Node<Prod<a, Color>>)
              => {
                r
                if/**/ f == (Color::Black{}) => {
                  return baldl<a>(t1a, ab, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{u2, Prod<a, Color>{b, Color::Black{}}, u3}, Prod<a, Color>{ca, Color::Black{}}, t4a});
                }/*Tag: Pattern Matching2*/
              }/*Tag: Pattern Matching2*/
            };
            panic!("match failed");
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        t.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ d == (Color::Red{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{join<a>(Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, t2a), Prod<a, Color>{ab, Color::Red{}}, t3a};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Red{}) => {
        t.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ d == (Color::Black{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Red{}}, join<a>(t2a, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba})};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn fold<a, b> (f : fn(a) fn(b) b, x1 : List<a>, s : b) -> b {
  {
    fb := f;
    x1.(Cons<a>)
    => {
      sb := s;
      return fold<a, b>(fb, xsa, ((fb(xa))(sb)));/*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  {
    List<a>::Nil<a>{} => sb := s;
                         return sb;/*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  panic!("match failed");
}

fn balil<a> (x0 : Tree<Prod<a, Color>>, c : a, t4 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    x0.(Node<Prod<a, Color>>)
    => {
      q.(Node<Prod<a, Color>>)
      => {
        r
        if/**/ d == (Color::Red{}) => {
          p
          if/**/ e == (Color::Red{}) => {
            cb := c;
            t4b := t4;
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1a, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{cb, Color::Black{}}, t4b}};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      q
      if/**/ e == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ f == (Color::Red{}) => {
            cb := c;
            t4b := t4;
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{cb, Color::Black{}}, t4b}};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      r.(Node<Prod<a, Color>>)
      => {
        s
        if/**/ d == (Color::Black{}) => {
          q
          if/**/ e == (Color::Red{}) => {
            p.(Node<Prod<a, Color>>)
            => {
              t
              if/**/ f == (Color::Red{}) => {
                cb := c;
                t4b := t4;
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Black{}}, t2a}, Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{cb, Color::Black{}}, t4b}};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ab := c;
            t2a := t4;
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p
      if/**/ e == (Color::Black{}) => {
        ab := c;
        t2a := t4;
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{va, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    if/**/ e == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) && d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      ab := c;
      t2a := t4;
      return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, vaa, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p.(Node<Prod<a, Color>>)
      => {
        q
        if/**/ e == (Color::Black{}) => {
          ab := c;
          t2a := t4;
          return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, vaa, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vb, Prod<a, Color>{vea, Color::Black{}}, vda}}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      q.(Node<Prod<a, Color>>)
      => {
        r
        if/**/ d == (Color::Black{}) => {
          p
          if/**/ e == (Color::Black{}) => {
            ab := c;
            t2a := t4;
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vca, Prod<a, Color>{vfa, Color::Black{}}, vea}, Prod<a, Color>{va, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    if/**/ d == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p.(Node<Prod<a, Color>>)
      => {
        q
        if/**/ e == (Color::Black{}) => {
          ab := c;
          t2a := t4;
          return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vca, Prod<a, Color>{vfa, Color::Black{}}, vea}, vaa, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      q.(Node<Prod<a, Color>>)
      => {
        r
        if/**/ d == (Color::Black{}) => {
          p.(Node<Prod<a, Color>>)
          => {
            s
            if/**/ e == (Color::Black{}) => {
              ab := c;
              t2a := t4;
              return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vca, Prod<a, Color>{vfa, Color::Black{}}, vea}, vaa, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vb, Prod<a, Color>{vha, Color::Black{}}, vga}}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
            }/*Tag: Pattern Matching2*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ d == (Color::Black{}) => {
        ab := c;
        t2a := t4;
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}, Prod<a, Color>{ab, Color::Black{}}, t2a};/*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn baldr<a> (t1 : Tree<Prod<a, Color>>, aa : a, x2 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    t1b := t1;
    ac := aa;
    x2.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Red{}) => {
        return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t2a, Prod<a, Color>{ba, Color::Black{}}, t3a}};
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching3*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ba := aa;
        Tree<Prod<a, Color>>::Leaf<Prod<a,
 Color>>{} => return balil<a>(Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Red{}}, t2a}, ba, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{});/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        ba := aa;
        x2.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ d == (Color::Black{}) => {
            return balil<a>(Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t1b, Prod<a, Color>{ac, Color::Red{}}, t2a}, ba, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba});
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      q
      if/**/ d == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ e == (Color::Black{}) => {
            ca := aa;
            Tree<Prod<a, Color>>::Leaf<Prod<a,
     Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{balil<a>(paint<a>(Color::Red{}, t1b), ac, t2a), Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{ca, Color::Black{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      q
      if/**/ d == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ e == (Color::Black{}) => {
            ca := aa;
            x2.(Node<Prod<a, Color>>)
            => {
              s
              if/**/ f == (Color::Black{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{balil<a>(paint<a>(Color::Red{}, t1b), ac, t2a), Prod<a, Color>{ba, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{t3a, Prod<a, Color>{ca, Color::Black{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}}};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ac := aa;
            Tree<Prod<a, Color>>::Leaf<Prod<a,
     Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    if/**/ c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p
      if/**/ d == (Color::Red{}) => {
        ac := aa;
        Tree<Prod<a, Color>>::Leaf<Prod<a,
 Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      q
      if/**/ c == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ d == (Color::Red{}) => {
            ac := aa;
            Tree<Prod<a, Color>>::Leaf<Prod<a,
     Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vb, Prod<a, Color>{vca, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vaa, Prod<a, Color>{vfa, Color::Red{}}, vea}}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => ac := aa;
            x2.(Node<Prod<a, Color>>)
            => {
              p
              if/**/ c == (Color::Black{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{va, Prod<a, Color>{vca, Color::Black{}}, vba}};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*//*Tag: Pattern Matching1*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    if/**/ c == (Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}) => {
      p
      if/**/ d == (Color::Red{}) => {
        ac := aa;
        x2.(Node<Prod<a, Color>>)
        => {
          q
          if/**/ e == (Color::Black{}) => {
            return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vaa, Prod<a, Color>{vfa, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vd, Prod<a, Color>{vca, Color::Black{}}, vba}};
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    t1.(Node<Prod<a, Color>>)
    => {
      q
      if/**/ c == (Color::Red{}) => {
        p.(Node<Prod<a, Color>>)
        => {
          r
          if/**/ d == (Color::Red{}) => {
            ac := aa;
            x2.(Node<Prod<a, Color>>)
            => {
              s
              if/**/ e == (Color::Black{}) => {
                return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vaa, Prod<a, Color>{vfa, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{vda, Prod<a, Color>{via, Color::Red{}}, vha}}, Prod<a, Color>{ac, Color::Red{}}, Tree<Prod<a, Color>>::Node<Prod<a, Color>>{ve, Prod<a, Color>{vca, Color::Black{}}, vba}};
              }/*Tag: Pattern Matching2*/
            }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
          }/*Tag: Pattern Matching2*/
        }/*Tag: Pattern Matching2*/
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn equal_tree<a> (a_ Equal<a>, x0 : Tree<a>, x1 : Tree<a>) -> bool {
  {
    Tree<a>::Leaf<a>{} => x1.(Node<a>)
                          => {
                            return false;
                          }/*Tag: Pattern Matching2*//*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<a>)
    => {
      Tree<a>::Leaf<a>{} => return false;/*Tag: Pattern Matching1*/
    }/*Tag: Pattern Matching2*/
  };
  {
    x0.(Node<a>)
    => {
      x1.(Node<a>)
      => {
        return equal_tree<a>(a_/*Tag: Dict without Classrels*/, x21a, y21a) && (eq<a>(a_/*Tag: Dict without Classrels*/, x22a, y22a) && equal_tree<a>(a_/*Tag: Dict without Classrels*/, x23a, y23a));
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  {
    Tree<a>::Leaf<a>{} => Tree<a>::Leaf<a>{} => return true;/*Tag: Pattern Matching1*//*Tag: Pattern Matching1*/
  };
  panic!("match failed");
}

fn color<a> (x0 : Tree<Prod<a, Color>>) -> Color {
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Color::Black{};/*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      => {
        return ca;
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn del<a> (a1_ Equal<a>, a2_ Linorder<a>, x : a, xa1 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{};/*Tag: Pattern Matching1*/
  };
  {
    xb := x;
    xa1.(Node<Prod<a, Color>>)
    => {
      p
      => {
        target := cmp<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
        {
          CmpVal::LT{} => targeu := (!equal_tree<Prod<a, Color>>(EqualProd<a, Color>(a1_/*Tag: Dict without Classrels*/, EqualColor()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, la, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{})) && equal_color(color<a>(la), Color::Black{});
                          {
                            true => return baldl<a>(del<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), ab, ra);/*Tag: Pattern Matching1*/
                          };
                          {
                            false => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{del<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), Prod<a, Color>{ab, Color::Red{}}, ra};/*Tag: Pattern Matching1*/
                          };
                          panic!("match failed");/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::EQ{} => return join<a>(la, ra);/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::GT{} => targeu := (!equal_tree<Prod<a, Color>>(EqualProd<a, Color>(a1_/*Tag: Dict without Classrels*/, EqualColor()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, ra, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{})) && equal_color(color<a>(ra), Color::Black{});
                          {
                            true => return baldr<a>(la, ab, del<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra));/*Tag: Pattern Matching1*/
                          };
                          {
                            false => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{la, Prod<a, Color>{ab, Color::Red{}}, del<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra)};/*Tag: Pattern Matching1*/
                          };
                          panic!("match failed");/*Tag: Pattern Matching1*/
        };
        panic!("match failed");
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic!("match failed");
}

fn ins<a> (a1_ Equal<a>, a2_ Linorder<a>, x : a, xa1 : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  {
    xb := x;
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}, Prod<a, Color>{xb, Color::Red{}}, Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{}};/*Tag: Pattern Matching1*//*Tag: Pattern Matching3*/
  };
  {
    xb := x;
    xa1.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Black{}) => {
        target := cmp<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
        {
          CmpVal::LT{} => return balil<a>(ins<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), ab, ra);/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::EQ{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{la, Prod<a, Color>{ab, Color::Black{}}, ra};/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::GT{} => return balir<a>(la, ab, ins<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra));/*Tag: Pattern Matching1*/
        };
        panic!("match failed");
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  {
    xb := x;
    xa1.(Node<Prod<a, Color>>)
    => {
      p
      if/**/ c == (Color::Red{}) => {
        target := cmp<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ab);
        {
          CmpVal::LT{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{ins<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, la), Prod<a, Color>{ab, Color::Red{}}, ra};/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::EQ{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{la, Prod<a, Color>{ab, Color::Red{}}, ra};/*Tag: Pattern Matching1*/
        };
        {
          CmpVal::GT{} => return Tree<Prod<a, Color>>::Node<Prod<a, Color>>{la, Prod<a, Color>{ab, Color::Red{}}, ins<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, xb, ra)};/*Tag: Pattern Matching1*/
        };
        panic!("match failed");
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*//*Tag: Pattern Matching3*/
  };
  panic!("match failed");
}

fn insert<a> (a1_ Equal<a>, a2_ Linorder<a>, x : a, t : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  return paint<a>(Color::Black{}, ins<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, x, t));
}

fn empty<a> () -> Tree<Prod<a, Color>> {
  return Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{};
}

fn t1 () -> Tree<Prod<Bigint.Int, Color>> {
  return fold<Bigint.Int, Tree<Prod<Bigint.Int, Color>>>(fn /*Tag: Anonymous Function*/ (a : Bigint.Int) -> fn(Tree<Prod<Bigint.Int, Color>>) Tree<Prod<Bigint.Int, Color>> {
                   return fn /*Tag: Anonymous Function*/ (b : Tree<Prod<Bigint.Int, Color>>) -> Tree<Prod<Bigint.Int, Color>> {
                            return insert<Bigint.Int>(EqualInteger()/*Tag: Dict without Classrels*/, LinorderInteger()/*Tag: Dict without Classrels*/, a, b);
                          };
                 }, List<Bigint.Int>::Cons<Bigint.Int>{BigInt::parse_bytes(b"1", 10).unwrap(), List<Bigint.Int>::Cons<Bigint.Int>{BigInt::parse_bytes(b"2", 10).unwrap(), List<Bigint.Int>::Cons<Bigint.Int>{BigInt::parse_bytes(b"3", 10).unwrap(), List<Bigint.Int>::Cons<Bigint.Int>{BigInt::parse_bytes(b"4", 10).unwrap(), List<Bigint.Int>::Cons<Bigint.Int>{BigInt::parse_bytes(b"5", 10).unwrap(), List<Bigint.Int>::Nil<Bigint.Int>{}}}}}}, empty<Bigint.Int>());
}

fn invc<a> (x0 : Tree<Prod<a, Color>>) -> bool {
  {
    Tree<Prod<a, Color>>::Leaf<Prod<a, Color>>{} => return true;/*Tag: Pattern Matching1*/
  };
  {
    x0.(Node<Prod<a, Color>>)
    => {
      p
      => {
        return ((!equal_color(ca, Color::Red{})) || equal_color(color<a>(la), Color::Black{}) && equal_color(color<a>(ra), Color::Black{})) && (invc<a>(la) && invc<a>(ra));
      }/*Tag: Pattern Matching2*/
    }/*Tag: Pattern Matching2*/
  };
  panic!("match failed");
}

fn delete_list<a> (a1_ Equal<a>, a2_ Linorder<a>, xs : List<a>, aa : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
  return fold<a, Tree<Prod<a, Color>>>(fn /*Tag: Anonymous Function*/ (ab : a) -> fn(Tree<Prod<a, Color>>) Tree<Prod<a, Color>> {
 return fn /*Tag: Anonymous Function*/ (b : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
          return del<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, ab, b);
        };
                                       }, xs, aa);
}

fn trees_equal<a> (a_ Equal<a>, aa : Tree<Prod<a, Color>>, b : Tree<Prod<a, Color>>) -> bool {
  return equal_tree<Prod<a, Color>>(EqualProd<a, Color>(a_/*Tag: Dict without Classrels*/, EqualColor()/*Tag: Dict without Classrels*/)/*Tag: Dict without Classrels*/, aa, b);
}

fn tree_from_list<a> (a1_ Equal<a>, a2_ Linorder<a>, xs : List<a>) -> Tree<Prod<a, Color>> {
  return fold<a, Tree<Prod<a, Color>>>(fn /*Tag: Anonymous Function*/ (aa : a) -> fn(Tree<Prod<a, Color>>) Tree<Prod<a, Color>> {
 return fn /*Tag: Anonymous Function*/ (b : Tree<Prod<a, Color>>) -> Tree<Prod<a, Color>> {
          return insert<a>(a1_/*Tag: Dict without Classrels*/, a2_/*Tag: Dict without Classrels*/, aa, b);
        };
                                       }, xs, empty<a>());
}
