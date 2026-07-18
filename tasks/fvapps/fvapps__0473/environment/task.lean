import Mathlib

def count_triplets (arr: List Nat) : Nat :=
  sorry

theorem count_triplets_non_negative (arr: List Nat) :
  count_triplets arr ≥ 0 :=
sorry

theorem count_triplets_is_nat (arr: List Nat) :
  count_triplets arr = count_triplets arr :=
sorry

theorem count_triplets_append_zero (arr: List Nat) :
  count_triplets (arr ++ [0]) ≥ count_triplets arr :=
sorry
