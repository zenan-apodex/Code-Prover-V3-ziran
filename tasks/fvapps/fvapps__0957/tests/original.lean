import Mathlib

def find_max_peace_distance (houses : List Int) : Int := sorry

theorem peace_distance_nonnegative (houses : List Int) 
  (h : houses.length ≥ 2) :
  find_max_peace_distance houses ≥ 0 := sorry

theorem peace_distance_upper_bound (houses : List Int)
  (h : houses.length ≥ 2) :
  find_max_peace_distance houses ≤ (List.maximum? houses).getD 0 - (List.minimum? houses).getD 0 := sorry
