import Mathlib

def butlast : List α → List α
  | [] => []
  | [_x] => []
  | x::xs => x::(butlast xs)

theorem prop_50 (xs: List α) :
  (butlast xs = List.take (List.length xs - 1) xs):= by sorry
