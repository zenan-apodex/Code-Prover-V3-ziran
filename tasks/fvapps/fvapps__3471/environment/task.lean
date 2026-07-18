import Mathlib

def mod256_without_mod (x : Int) : Int := sorry

theorem mod256_matches_regular_mod (x : Int) :
  mod256_without_mod x = x % 256 := sorry

theorem output_range (x : Int) :
  0 ≤ mod256_without_mod x ∧ mod256_without_mod x ≤ 255 := sorry

theorem periodic_property (x n : Int) : 
  mod256_without_mod x = mod256_without_mod (x + n * 256) := sorry
