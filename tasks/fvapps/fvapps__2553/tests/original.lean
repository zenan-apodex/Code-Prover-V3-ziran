import Mathlib

def num_prime_arrangements (n: Nat) : Nat := sorry

theorem num_prime_arrangements_positive (n: Nat) :
  n ≥ 1 → num_prime_arrangements n > 0 := sorry

theorem num_prime_arrangements_modulo_bound (n: Nat) :
  n ≥ 1 → num_prime_arrangements n < 10^9 + 7 := sorry

theorem num_prime_arrangements_base_case : 
  num_prime_arrangements 1 = 1 := sorry

theorem num_prime_arrangements_ordering (n: Nat) :
  n > 1 → (num_prime_arrangements n - num_prime_arrangements (n-1)) ≤ 10^9 + 7 := sorry
