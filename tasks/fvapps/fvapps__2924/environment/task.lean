import Mathlib

def are_coprime (a b : Int) : Bool := sorry

theorem self_coprime (n : Int) : 
  are_coprime n n = (n.natAbs = 1) := sorry

theorem symmetry (n m : Int) : 
  are_coprime n m = are_coprime m n := sorry

theorem sign_invariance (n m : Int) :
  are_coprime n m = are_coprime n.natAbs m.natAbs := sorry

theorem multiplication_property (n m k : Int) :
  (are_coprime n m ∧ are_coprime n k) → are_coprime n (m * k) := sorry

theorem zero_coprime (n : Int) :
  are_coprime n 0 = (n.natAbs = 1) := sorry
