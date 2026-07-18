import Mathlib

def Matrix (α : Type) := List (List α)

def score_matrix (matrix : Matrix Int) : Int := sorry





theorem score_matrix_single_element
  (x : Int) :
  score_matrix [[x]] = x := sorry

theorem score_matrix_zero
  (n : Nat)
  (h : n > 0) :
  score_matrix (List.replicate n (List.replicate n 0)) = 0 := sorry
