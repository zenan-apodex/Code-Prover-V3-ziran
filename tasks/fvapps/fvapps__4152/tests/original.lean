import Mathlib

def mygcd (x y : Int) : Int :=
  sorry

def abs (x : Int) : Int :=
  sorry

theorem gcd_positive_integers {x y : Int} (hx : x > 0) (hy : y > 0) :
  let g := mygcd x y
  g > 0 ∧ x % g = 0 ∧ y % g = 0 :=
  sorry



theorem gcd_identity {x : Int} :
  mygcd x x = x :=
  sorry

theorem gcd_associative {x y : Int} (hx : x > 0) (hy : y > 0) :
  mygcd (x * y) x = x :=
  sorry
