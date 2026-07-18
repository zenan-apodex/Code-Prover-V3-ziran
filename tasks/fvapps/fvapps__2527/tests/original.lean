import Mathlib

def getSum (a b : Int) : Int := sorry

theorem getSum_with_zero (a : Int) : 
  getSum a 0 = a ∧ getSum 0 a = a := sorry

theorem getSum_commutative (a b : Int) :
  getSum a b = getSum b a := sorry

theorem getSum_associative (a b c : Int) :
  getSum (getSum a b) c = getSum a (getSum b c) := sorry

theorem getSum_negation (a : Int) :
  getSum a (-a) = 0 := sorry
