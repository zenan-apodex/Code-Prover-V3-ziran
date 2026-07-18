import Mathlib

theorem xor_commutative (a b : Bool) : 
  Bool.xor a b = Bool.xor b a := sorry

theorem xor_false (a : Bool) :
  Bool.xor false a = a := sorry

theorem xor_self (a : Bool) :
  Bool.xor a a = false := sorry

theorem xor_double (a b : Bool) :
  Bool.xor (Bool.xor a b) b = a := sorry
