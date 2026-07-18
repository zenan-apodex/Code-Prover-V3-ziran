import Mathlib

def butlast : List α → List α
  | [] => []
  | [_x] => []
  | x::xs => x::(butlast xs)

theorem prop_67 (xs: List Nat) :
  List.length (butlast xs) = List.length xs - 1:= by sorry
