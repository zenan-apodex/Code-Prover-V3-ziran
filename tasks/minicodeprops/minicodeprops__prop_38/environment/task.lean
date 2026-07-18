import Mathlib

theorem prop_38 (n: Nat) (xs: List Nat) :
  List.count n (xs ++ [n]) = (List.count n xs).succ:= by sorry
