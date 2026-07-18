import Mathlib

def odd_not_prime (n : Nat) : Nat := sorry
def not_prime (n : Nat) : Bool := sorry

theorem odd_not_prime_increasing (n : Nat) (h : n > 0) :
  odd_not_prime n ≥ odd_not_prime (n-1) := sorry

theorem odd_not_prime_bounds (n : Nat) (h : n > 0) :
  odd_not_prime n ≥ 0 ∧ odd_not_prime n ≤ (n+1)/2 := sorry
