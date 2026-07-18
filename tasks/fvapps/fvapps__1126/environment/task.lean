import Mathlib

def max_regions_after_v_roads (n: Nat) : Nat :=
sorry

theorem max_regions_always_positive (n: Nat) (h: n > 0) : 
  max_regions_after_v_roads n > 0 :=
sorry

theorem max_regions_monotonic (n: Nat) (h: n > 0) :
  max_regions_after_v_roads n < max_regions_after_v_roads (n + 1) := 
sorry

theorem max_regions_known_values :
  max_regions_after_v_roads 1 = 2 ∧ 
  max_regions_after_v_roads 2 = 7 ∧
  max_regions_after_v_roads 3 = 16 :=
sorry
