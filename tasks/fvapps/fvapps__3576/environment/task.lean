import Mathlib

def longest (words : List String) : Nat :=
  sorry

@[simp]
theorem longest_equals_max_length (words : List String) (h : words ≠ []) :
  longest words = (words.map String.length).maximum?.getD 0
  := by sorry

theorem longest_min_length_5 (words : List String) (h₁ : words ≠ []) 
  (h₂ : ∀ w ∈ words, String.length w ≥ 5) :
  longest words ≥ 5
  := by sorry

theorem longest_max_length_10 (words : List String) (h₁ : words ≠ []) 
  (h₂ : ∀ w ∈ words, String.length w ≤ 10) :
  longest words ≤ 10
  := by sorry

theorem longest_empty_list :
  longest [] = 0 ∧ longest [] ≠ longest ["a"]
  := by sorry
