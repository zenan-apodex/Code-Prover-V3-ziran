import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)

theorem prop_59 (xs: List Nat) (ys: List Nat) :
  ys = [] →  last (xs ++ ys) = last xs:= by sorry
