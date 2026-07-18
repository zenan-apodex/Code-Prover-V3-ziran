import Mathlib

def count_sixes (n : Nat) : Nat := sorry

theorem count_sixes_non_negative (n : Nat) (h : n > 0) :
  count_sixes n ≥ 0 := sorry

theorem count_sixes_monotonic (n : Nat) (h : n > 1) :
  count_sixes n ≥ count_sixes (n-1) := sorry
