import Mathlib

def is_bouncy (n : Nat) : Bool := sorry

def digits_sorted (n : Nat) : Bool := sorry
def digits_sorted_reverse (n : Nat) : Bool := sorry

theorem small_numbers_not_bouncy (n : Nat) (h : n < 100) : 
  ¬ is_bouncy n := sorry
