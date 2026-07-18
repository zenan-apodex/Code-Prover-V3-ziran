import Mathlib

def enough (cap on wait : Nat) : Nat := sorry

theorem enough_nonneg (cap on wait : Nat) :
  cap > 0 → enough cap on wait ≥ 0 := sorry

theorem enough_fits (cap on wait : Nat) :
  cap > 0 → on + wait ≤ cap → enough cap on wait = 0 := sorry
