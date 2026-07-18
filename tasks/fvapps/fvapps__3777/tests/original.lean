import Mathlib

def quicksum (s : String) : Nat :=
  sorry



theorem quicksum_invalid_packets (s : String)
  (h : ∃ c ∈ s.data, c ≠ ' ' ∧ ¬(65 ≤ c.toNat ∧ c.toNat ≤ 90)) :
  quicksum s = 0 :=
  sorry
