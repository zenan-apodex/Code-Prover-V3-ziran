import Mathlib

def toString (n : Nat) : List Nat := sorry

def distinctDigitYear (year : Nat) : Nat := sorry

def hasDistinctDigits (n : Nat) : Bool := sorry

theorem distinct_digit_year_greater_than_input (year : Nat)
  (h : year ≥ 1000 ∧ year ≤ 9000) :
  distinctDigitYear year > year := sorry

theorem distinct_digit_year_has_four_digits (year : Nat)
  (h : year ≥ 1000 ∧ year ≤ 9000) :
  distinctDigitYear year ≥ 1000 := sorry

theorem distinct_digit_year_has_distinct_digits (year : Nat) 
  (h : year ≥ 1000 ∧ year ≤ 9000) :
  hasDistinctDigits (distinctDigitYear year) = true := sorry

theorem distinct_digit_year_is_minimal (year : Nat)
  (h : year ≥ 1000 ∧ year ≤ 9000) :
  ∀ y, year < y → y < distinctDigitYear year →
    hasDistinctDigits y = false := sorry
