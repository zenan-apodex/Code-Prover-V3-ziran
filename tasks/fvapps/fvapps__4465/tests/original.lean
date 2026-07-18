import Mathlib

def super_size (n : Nat) : Nat := sorry

theorem super_size_same_digits {n : Nat} : 
  (toString n).data = (toString (super_size n)).data := sorry

theorem super_size_greater_or_equal {n : Nat} :
  super_size n ≥ n := sorry

theorem super_size_idempotent {n : Nat} :
  super_size (super_size n) = super_size n := sorry

theorem super_size_same_length {n : Nat} :
  (toString n).length = (toString (super_size n)).length := sorry
