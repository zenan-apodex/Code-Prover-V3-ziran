import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)


def null : List α → Bool
  | [] => True
  | _ => False

theorem prop_62 (xs: List Nat) (x: Nat) :
  not (null xs) → last (x::xs) = last xs:= by sorry
