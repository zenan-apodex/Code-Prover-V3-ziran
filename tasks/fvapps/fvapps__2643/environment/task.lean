import Mathlib

def symmetric_subscribers (eng : List Int) (french : List Int) : Nat := sorry

theorem symmetric_subscribers_non_negative 
  (eng : List Int) (french : List Int) : 
  symmetric_subscribers eng french ≥ 0 := sorry



theorem symmetric_subscribers_upper_bound 
  (eng : List Int) (french : List Int) :
  symmetric_subscribers eng french ≤ List.length eng + List.length french := sorry

theorem symmetric_subscribers_identical_lists
  (nums : List Int) :
  symmetric_subscribers nums nums = 0 := sorry
