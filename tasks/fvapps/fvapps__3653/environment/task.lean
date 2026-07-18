import Mathlib

def tops (s : String) : String := sorry 

theorem tops_empty_or_short_strings (s : String) :
  (s = "") → (tops s = "") ∧ 
  (s.length ≤ 2) → (tops s = "") ∧
  (tops s).length ≤ s.length := by sorry

theorem tops_result_pattern (s : String) :
  s.length ≥ 10 →
  (∀ c, c ∈ (tops s).data.take 2 → c ∈ s.data) ∧ 
  (∀ c, c ∈ ((tops s).data.drop 2).take 3 → c ∈ s.data) ∧
  (∀ c, c ∈ ((tops s).data.drop 5).take 4 → c ∈ s.data) := by sorry
