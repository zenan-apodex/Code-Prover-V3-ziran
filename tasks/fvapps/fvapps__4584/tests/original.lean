import Mathlib

def invert (xs : List Int) : List Int := sorry

def abs (n : Int) : Int :=
  if n ≥ 0 then n else -n

theorem invert_length (xs : List Int) :
  (invert xs).length = xs.length := sorry



theorem invert_involution (xs : List Int) :
  invert (invert xs) = xs := sorry



theorem invert_empty : 
  invert [] = [] := sorry
