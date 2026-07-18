import Mathlib

def find_last_laddu (n : Nat) : Nat :=
sorry

theorem find_last_laddu_bounds (n : Nat) (h : n > 0) : 
  let result := find_last_laddu n
  0 < result ∧ result ≤ n := 
sorry



theorem find_last_laddu_next_power_exceeds (n : Nat) (h : n > 0) :
  let result := find_last_laddu n
  2 * result > n :=
sorry
