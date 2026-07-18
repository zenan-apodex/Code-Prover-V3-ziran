import Mathlib

def pyramid (n : Int) : List (List Nat) := sorry

theorem pyramid_length {n : Nat} : 
  List.length (pyramid n) = n := sorry

theorem pyramid_row_length {n : Nat} {i : Nat} :
  i < n → List.length (List.get! (pyramid n) i) = i + 1 := sorry

theorem pyramid_all_ones {n : Nat} : 
  ∀ row ∈ pyramid n, ∀ x ∈ row, x = 1 := sorry
