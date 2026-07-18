import Mathlib

def pascal (n : Nat) : List (List Nat) := sorry

theorem pascal_row_count {n : Nat} (h : n > 0) : 
  List.length (pascal n) = n := sorry
