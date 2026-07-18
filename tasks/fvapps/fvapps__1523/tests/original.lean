import Mathlib

/- Helper functions for List operations -/
def List.sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + List.sum xs

def List.maximum' : List Nat → Nat
  | [] => 0
  | [x] => x
  | x :: xs => max x (List.maximum' xs)

/- Main function -/
def calculate_max_earnings (n : Nat) (fees : List Nat) : Nat :=
  sorry

/- Theorems -/
theorem calculate_max_earnings_bounded (n : Nat) (fees : List Nat) :
  n > 0 → fees.length = n → calculate_max_earnings n fees ≤ fees.sum :=
  sorry

theorem calculate_max_earnings_nonnegative (n : Nat) (fees : List Nat) :
  n > 0 → fees.length = n → calculate_max_earnings n fees ≥ 0 :=
  sorry





theorem calculate_max_earnings_returns_number (n : Nat) (fees : List Nat) :
  n > 0 → fees.length = n → calculate_max_earnings n fees = calculate_max_earnings n fees :=
  sorry
