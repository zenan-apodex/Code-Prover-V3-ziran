import Mathlib

def odd_count (n : Nat) : Nat :=
  sorry

theorem odd_count_nonnegative (n : Nat) :
  odd_count n ≥ 0 :=
  sorry

theorem odd_count_half_input (n : Nat) :
  odd_count n = n / 2 :=
  sorry

theorem odd_count_consecutive_diff (n : Nat) :
  odd_count (n + 1) - odd_count n ≤ 1 :=
  sorry
