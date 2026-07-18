import Mathlib

def remainder (dividend divisor : Nat) : Nat := sorry

theorem remainder_properties {dividend divisor : Nat} (h : divisor > 0) : 
  let r := remainder dividend divisor
  (r ≥ 0) ∧ 
  (r < divisor) ∧ 
  (dividend = (dividend / divisor) * divisor + r)
  := sorry

theorem remainder_matches_modulo {dividend divisor : Nat} (h : divisor > 0) :
  remainder dividend divisor = dividend % divisor := sorry
