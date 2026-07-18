import Mathlib

def repeating_fractions (n : Int) (d : Int) : String := sorry

theorem integer_division_gives_no_decimal (n : Int) : 
  repeating_fractions n 1 = toString n := 
sorry

theorem division_by_zero_undefined (n : Int) :
  ∀ (d : Int), d = 0 → repeating_fractions n d = "undefined" :=
sorry 

theorem one_third_is_point_three_repeating :
  repeating_fractions 1 3 = "0.(3)" :=
sorry
