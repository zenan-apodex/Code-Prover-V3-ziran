import Mathlib

def increment_or_decrement (n : Int) : Int := sorry

theorem increment_or_decrement_divisible_by_4 (n : Int) : 
  n % 4 = 0 → increment_or_decrement n = n + 1 := sorry

theorem increment_or_decrement_not_divisible_by_4 (n : Int) :
  n % 4 ≠ 0 → increment_or_decrement n = n - 1 := sorry

theorem increment_or_decrement_distance (n : Int) :
  (increment_or_decrement n - n = 1) ∨ (increment_or_decrement n - n = -1) := sorry 

theorem increment_or_decrement_not_idempotent (n : Int) :
  increment_or_decrement (increment_or_decrement n) ≠ increment_or_decrement n := sorry
