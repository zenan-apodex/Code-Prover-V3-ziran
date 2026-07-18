import Mathlib

def count_number (n : Nat) (x : Nat) : Nat :=
  sorry

theorem count_number_non_negative (n : Nat) (x : Nat) (h : n > 0) :
  count_number n x ≥ 0 :=
sorry

theorem count_number_upper_bound (n : Nat) (x : Nat) (h : n > 0) : 
  count_number n x ≤ n :=
sorry



theorem count_number_above_max (n : Nat) (h : n > 0) :
  count_number n (n*n + 1) = 0 :=
sorry
