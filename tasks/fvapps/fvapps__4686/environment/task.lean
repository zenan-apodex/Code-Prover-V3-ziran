import Mathlib

def double_every_other : List Int → List Int
  | _ => sorry

theorem double_every_other_length (lst : List Int) :
  (double_every_other lst).length = lst.length :=
sorry





theorem double_every_other_empty :
  double_every_other [] = [] :=
sorry

theorem double_every_other_singleton (x : Int) :
  double_every_other [x] = [x] :=
sorry
