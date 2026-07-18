import Mathlib

def count_negatives (grid : List (List Int)) : Nat := sorry

theorem count_negatives_matches_direct_count (grid : List (List Int)) : 
  count_negatives grid = (grid.bind (·.filter (·<0))).length := sorry

theorem count_negatives_nonnegative (grid : List (List Int)) :
  count_negatives grid ≥ 0 := sorry
