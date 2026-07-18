import Mathlib

def abacaba (n : Nat) : Char := sorry

theorem abacaba_is_lowercase (n : Nat) : 
  let result := abacaba n
  97 ≤ result.toNat ∧ result.toNat ≤ 122 := sorry
