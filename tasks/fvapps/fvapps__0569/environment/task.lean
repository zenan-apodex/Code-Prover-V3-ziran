import Mathlib

/- Function signature -/
def find_nth_sequence_element (n : Nat) : Nat := sorry

/- Theorems -/

theorem output_less_than_input {n : Nat} (h : n > 0) : 
  find_nth_sequence_element n < n := sorry
