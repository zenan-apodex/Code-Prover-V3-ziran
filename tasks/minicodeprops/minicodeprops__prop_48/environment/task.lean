import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)


def null : List α → Bool
  | [] => True
  | _ => False


def butlast : List α → List α
  | [] => []
  | [_x] => []
  | x::xs => x::(butlast xs)

theorem prop_48 (xs: List Nat) :
  not (null xs) → butlast xs ++ [last xs] = xs:= by sorry
