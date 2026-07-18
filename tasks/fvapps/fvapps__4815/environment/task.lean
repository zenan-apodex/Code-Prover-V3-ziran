import Mathlib

def is_very_even_number (n : Nat) : Bool := sorry

def digitSum (n : Nat) : Nat := sorry
def singleDigitSum (n : Nat) : Nat := sorry

theorem very_even_single_digit (n : Nat) :
  n < 10 → is_very_even_number n = (n % 2 = 0) := sorry

theorem very_even_digit_sum (n : Nat) :
  is_very_even_number n = (singleDigitSum n % 2 = 0) := sorry
