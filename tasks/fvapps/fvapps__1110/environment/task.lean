import Mathlib

def min_modifications (arr : List Nat) : Nat := sorry

theorem min_modifications_non_negative (arr : List Nat) :
  min_modifications arr ≥ 0 := sorry

theorem min_modifications_upper_bound (arr : List Nat) :
  min_modifications arr ≤ arr.length * arr.length := sorry

theorem min_modifications_empty :
  min_modifications [] = 0 := sorry
