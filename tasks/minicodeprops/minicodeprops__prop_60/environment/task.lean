import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)


def null : List α → Bool
  | [] => True
  | _ => False

theorem prop_60 (xs: List Nat) (ys: List Nat) :
  not (null ys) → last (xs ++ ys) = last ys:= by sorry
