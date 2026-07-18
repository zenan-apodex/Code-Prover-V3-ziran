import Mathlib

def mobius (n : Nat) : Int :=
  sorry

theorem mobius_output_range (n : Nat) (h : n > 0) : 
  mobius n = -1 ∨ mobius n = 0 ∨ mobius n = 1 :=
  sorry

theorem mobius_square_factors (n : Nat) (h : n > 1) :
  mobius (n * n) = 0 :=
  sorry
