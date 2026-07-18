import Mathlib

def bernoulli_number (n : Nat) : Rat :=
  sorry

theorem odd_bernoulli_numbers_are_zero (n : Nat)
  (h : n ≥ 3)
  (h₂ : n % 2 = 1) :
  bernoulli_number n = 0 :=
sorry

theorem bernoulli_numbers_are_rational (n : Nat) :
  ∃ r : Rat, bernoulli_number n = r ∨ bernoulli_number n = 0 :=
sorry

theorem first_bernoulli_number :
  bernoulli_number 0 = 1 :=
sorry

theorem second_bernoulli_number :
  bernoulli_number 1 = -1/2 :=
sorry
