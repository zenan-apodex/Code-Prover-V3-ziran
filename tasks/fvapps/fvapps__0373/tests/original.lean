import Mathlib

def max_profit (k : Nat) (prices : List Nat) : Nat :=
  sorry





theorem single_price_zero_profit (k : Nat) (p : Nat) : 
  max_profit k [p] = 0 := sorry

private def pairwise_profits (prices : List Nat) : Nat :=
  sorry





private def isSorted (l : List Nat) : Prop :=
  sorry

def lastElem (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | [x] => x
  | x::xs => lastElem xs
