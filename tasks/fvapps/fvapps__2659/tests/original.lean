import Mathlib

def last_chair (n : Nat) : Nat :=
  sorry

theorem last_chair_range {n : Nat} (h : n ≥ 3) :
  1 ≤ last_chair n ∧ last_chair n ≤ n := by
  sorry

theorem last_chair_value {n : Nat} (h : n ≥ 3) :
  last_chair n = n - 1 := by
  sorry
