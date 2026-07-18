import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)

theorem prop_16 (x: Nat) (xs: List Nat) :
 xs = [] →  last (x::xs) = x:= by sorry
