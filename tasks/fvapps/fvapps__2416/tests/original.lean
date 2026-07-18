import Mathlib

def is_perfect_square (n : Nat) : Bool := sorry

theorem perfect_squares {n : Nat} : 
  is_perfect_square (n * n) = true := sorry

theorem non_perfect_squares {n : Nat} : 
  n > 0 → is_perfect_square (n * n + 1) = false := sorry

theorem sqrt_integers {n : Nat} :
  is_perfect_square n = 
  (∃ m : Nat, m * m = n) := sorry
