import Mathlib

def max_pool_area (r : Nat) : Nat := sorry

theorem max_pool_area_quadratic {r : Nat} : 
  max_pool_area r = 2 * (r * r) := sorry

theorem max_pool_area_positive {r : Nat} (h : r > 0) : 
  max_pool_area r > 0 := sorry

theorem max_pool_area_zero_iff {r : Nat} :
  max_pool_area r = 0 ↔ r = 0 := sorry
