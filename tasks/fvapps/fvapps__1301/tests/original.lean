import Mathlib

def sorted (s : String) : String := sorry

def largest_digit_rearrangement (n : Nat) : Nat := sorry



theorem not_less_than_input (n : Nat) :
  largest_digit_rearrangement n ≥ n := sorry

theorem rearrangement_idempotent (n : Nat) :
  largest_digit_rearrangement (largest_digit_rearrangement n) = largest_digit_rearrangement n := sorry

theorem preserves_length (n : Nat) :
  (toString (largest_digit_rearrangement n)).length = (toString n).length := sorry
