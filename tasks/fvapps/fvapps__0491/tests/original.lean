import Mathlib

def find_substrings_in_wraparound (s: String) : Nat := sorry

theorem output_always_positive (s: String) : 
  find_substrings_in_wraparound s ≥ 0 := sorry

theorem single_char_min (s: String) :
  s.length ≥ 1 → find_substrings_in_wraparound s ≥ 1 := sorry
