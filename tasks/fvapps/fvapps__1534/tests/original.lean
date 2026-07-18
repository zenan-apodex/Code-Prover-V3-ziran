import Mathlib

class MyToString (α : Type) where
  toString : α → String

instance : MyToString Nat where
  toString := sorry

def solve_division (a : String) (b : String) (l : Nat) : Nat :=
  sorry



theorem division_by_zero :
  ∀ l : Nat, solve_division "1" "0" l = 0 ∨ solve_division "1" "0" l = 0 :=
sorry

theorem zero_numerator
  (l : Nat)
  (h : 1 ≤ l ∧ l ≤ 5) :
  solve_division "0" "1" l = 0 :=
sorry
