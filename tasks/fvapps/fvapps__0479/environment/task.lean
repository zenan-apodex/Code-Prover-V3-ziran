import Mathlib

def least_bricks (wall : List (List Nat)) : Nat := sorry







theorem least_bricks_identical_rows (n : Nat)
  (h : n > 0) :
  least_bricks (List.replicate n [1, 1]) = 0 := sorry

theorem least_bricks_empty :
  least_bricks [] = 0 := sorry
