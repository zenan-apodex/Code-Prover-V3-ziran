import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)

theorem prop_63 (n: Nat) (xs: List Nat) :
  n < List.length xs → last (List.drop n xs) = last xs:= by sorry
