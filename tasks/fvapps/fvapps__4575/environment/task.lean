import Mathlib

def smallest_integer (matrix : List (List Int)) : Nat :=
  sorry

theorem smallest_integer_result_nonnegative (matrix : List (List Int)) :
  0 ≤ smallest_integer matrix := sorry

theorem smallest_integer_not_in_matrix (matrix : List (List Int)) :
  ¬ (∃ row ∈ matrix, ∃ x ∈ row, x ≥ 0 ∧ x = smallest_integer matrix) := sorry



theorem negative_numbers_ignored (matrix : List (List Int)) :
  smallest_integer matrix = 
  smallest_integer (List.map (λ row => List.map (λ x => if x ≥ 0 then x else -1) row) matrix) := sorry
