import Mathlib

def find_safest_position (n : Nat) : Nat :=
  sorry

theorem safest_position_in_range (n : Nat) (h : n > 0) :
  let pos := find_safest_position n
  1 ≤ pos ∧ pos ≤ n :=
sorry

theorem safest_position_consistent (n : Nat) :
  find_safest_position n = find_safest_position n :=
sorry
