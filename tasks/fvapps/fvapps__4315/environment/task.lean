import Mathlib

def sum_them (n : Nat) : Nat := sorry

@[simp]
theorem sum_them_non_negative (n : Nat) : 
  sum_them n ≥ 0 := sorry

@[simp] 
theorem sum_them_zero :
  sum_them 0 = 0 := sorry

theorem sum_them_monotonic (n : Nat) :
  n > 0 → sum_them n > sum_them (n-1) := sorry

theorem sum_them_closed_form (n : Nat) :
  n > 0 → sum_them n = 2^(n-1) * (2^n - 1) := sorry
