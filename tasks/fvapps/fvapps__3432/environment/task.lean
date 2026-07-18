import Mathlib

def cipher (s : String) : String := sorry

theorem cipher_length_preservation {s : String} :
  s.any (fun c => 97 ≤ c.toNat ∧ c.toNat ≤ 122 ∨ c = ' ') →
  (cipher s).length = s.length := sorry
