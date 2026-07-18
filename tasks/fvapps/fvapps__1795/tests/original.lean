import Mathlib

def nQueen (n : Nat) : List Nat := sorry

def isValidSolution (n : Nat) (queens : List Nat) : Bool := sorry





theorem solution_size (n : Nat) (h : n ≥ 4) :
  (nQueen n).length = n := sorry

theorem queens_in_bounds (n : Nat) (h : n ≥ 4) :
  ∀ x ∈ nQueen n, 0 ≤ x ∧ x < n := sorry
