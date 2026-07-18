import Mathlib

def mouth_size (animal : String) : String := sorry

theorem mouth_size_range (animal : String) : 
  mouth_size animal = "small" ∨ mouth_size animal = "wide" := sorry

theorem mouth_size_alligator (animal : String) :
  mouth_size animal = (if animal.toLower = "alligator" then "small" else "wide") := sorry

theorem mouth_size_case_insensitive (animal : String) :
  mouth_size (animal.toLower) = mouth_size (animal.toUpper) := sorry

theorem mouth_size_whitespace_invariant (animal : String) :
  mouth_size animal = mouth_size (animal.trim) := sorry
