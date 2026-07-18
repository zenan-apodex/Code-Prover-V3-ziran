import Mathlib

def min_ops_to_zeros (s : String) : Nat := sorry





theorem output_bounds (s : String) :
  let result := min_ops_to_zeros s
  0 ≤ result ∧ result ≤ s.length := sorry

theorem empty_string :
  min_ops_to_zeros "" = 0 := sorry
