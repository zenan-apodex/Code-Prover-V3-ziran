import Mathlib

def is_power_of_two (n : Nat) : Bool := sorry 

def strongest_even (a b : Nat) : Nat := sorry

theorem power_of_two_cases (p : Nat) (h : p > 0 ∧ p ≤ 32) : 
  strongest_even (2^p - 1) (2^p + 1) = 2^p := sorry

theorem single_even_number (n : Nat) (h : n > 0) :
  strongest_even (2*n) (2*n) = 2*n := sorry

theorem small_range_properties (p : Nat) (h : p > 0 ∧ p ≤ 16) :
  strongest_even (2^p) (2^(p+1)) = 2^(p+1) := sorry
