import Mathlib

def padovan (n : Nat) : Nat := sorry

theorem padovan_positive (n : Nat) : 
  padovan n > 0 := sorry 

theorem padovan_first_three : 
  (padovan 0 = 1) ∧ (padovan 1 = 1) ∧ (padovan 2 = 1) := sorry

theorem padovan_recurrence (n : Nat) :
  padovan (n + 3) = padovan n + padovan (n + 1) := sorry

theorem padovan_monotonic (n : Nat) :
  n > 0 → padovan n ≥ padovan (n - 1) := sorry
