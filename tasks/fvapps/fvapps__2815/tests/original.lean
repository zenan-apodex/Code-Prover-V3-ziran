import Mathlib

def compress (s : String) : String := sorry

theorem compress_case_insensitive (s : String) : 
  compress s = compress s.toUpper ∧ compress s = compress s.toLower := by sorry

theorem compress_only_digits (s : String) :
  s ≠ "" → compress s ≠ "" → 
  (∀ c : Char, c ∈ (compress s).data → c.isDigit) := by sorry

theorem compress_maps_repeat_words (s : String) (i : Nat) :
  s ≠ "" →
  let words := s.toLower.split (· = ' ')
  i < words.length →
  let result := compress s
  String.toNat! ((result.data.get! i).toString) = words.indexOf (words.get! i) := by sorry
