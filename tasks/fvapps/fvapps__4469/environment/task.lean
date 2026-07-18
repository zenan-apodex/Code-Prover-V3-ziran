import Mathlib

def is_narcissistic : Nat → Bool := sorry

def poweredDigitsSum : Nat → Nat := sorry

theorem single_digit_narcissistic {n : Nat} (h : n < 10) : 
  is_narcissistic n = true := sorry

theorem narcissistic_sum_property {n : Nat} (h : is_narcissistic n = true) :
  poweredDigitsSum n = n := sorry

theorem non_narcissistic_sum_property {n : Nat} (h : is_narcissistic n = false) :
  poweredDigitsSum n ≠ n := sorry
