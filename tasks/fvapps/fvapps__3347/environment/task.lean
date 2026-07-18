import Mathlib

def abs (x : Int) : Int :=
  sorry

def minimum (a x : Int) : Int :=
  sorry

theorem minimum_makes_number_divisible (a x : Int) (h : x ≠ 0) :
  (a + minimum a x) % x = 0 ∨ (a - minimum a x) % x = 0 :=
  sorry
