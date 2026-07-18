import Mathlib

def count_odd_button_sums (n : Nat) (buttons : List Nat) : Nat := sorry

theorem result_non_negative (n : Nat) (buttons : List Nat) :
  count_odd_button_sums n buttons ≥ 0 := sorry







theorem single_button_gives_zero (n : Nat) :
  count_odd_button_sums 1 [n] = 0 := sorry
