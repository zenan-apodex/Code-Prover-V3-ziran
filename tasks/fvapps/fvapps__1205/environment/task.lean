import Mathlib

inductive BinaryString where
  | empty : BinaryString
  | cons : Bool → BinaryString → BinaryString

def solve_binary_string_flips : BinaryString → Nat
  | _ => sorry

theorem single_char_string_has_no_pairs (b : Bool) : 
  solve_binary_string_flips (BinaryString.cons b BinaryString.empty) = 0 := by
  sorry

theorem output_is_nonnegative (s : BinaryString) : 
  solve_binary_string_flips s ≥ 0 := by
  sorry

theorem empty_string_returns_zero :
  solve_binary_string_flips BinaryString.empty = 0 := by
  sorry
