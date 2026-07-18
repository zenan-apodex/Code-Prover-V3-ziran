import Mathlib

def solve_string_transformation (s1 s2 : String) : Int := sorry

theorem identical_strings_zero_transforms (s : String) :
  solve_string_transformation s s = 0 := sorry



theorem result_bounds {s1 s2 : String} :
  s1.length = s2.length →
  solve_string_transformation s1 s2 ≠ -1 →
  0 ≤ solve_string_transformation s1 s2 ∧ 
  solve_string_transformation s1 s2 ≤ s1.length := sorry
