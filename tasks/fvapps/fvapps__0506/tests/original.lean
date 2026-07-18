import Mathlib

def myAtoi (s : String) : Int := sorry

theorem myAtoi_within_bounds (s : String) :
  -2147483648 ≤ myAtoi s ∧ myAtoi s ≤ 2147483647 := sorry

theorem myAtoi_leading_whitespace (s : String) :
  myAtoi ("   " ++ s) = myAtoi s := sorry



theorem myAtoi_signs_positive (n : Int) 
  (h : 0 ≤ n ∧ n ≤ 2147483647) :
  myAtoi ("+" ++ toString n) = n := sorry

theorem myAtoi_signs_negative (n : Int)
  (h : 0 ≤ n ∧ n ≤ 2147483647) :
  myAtoi ("-" ++ toString n) = -min n 2147483648 := sorry
