import Mathlib

def cup_and_balls (b : Nat) (swaps : List (List Nat)) : Nat := sorry



theorem empty_swaps_preserves_position {b : Nat}
  (h1 : b > 0) (h2 : b ≤ 100) :
  cup_and_balls b [] = b := sorry
