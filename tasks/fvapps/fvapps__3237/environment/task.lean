import Mathlib

inductive EvenOdd where
  | Even : EvenOdd
  | Odd : EvenOdd
deriving Repr, BEq

def even_or_odd (n : Int) : EvenOdd := sorry

theorem even_or_odd_valid (x : Int) : 
  even_or_odd x = (if x % 2 = 0 then EvenOdd.Even else EvenOdd.Odd) := sorry

theorem even_or_odd_consistent_add2 (x : Int) :
  even_or_odd x = even_or_odd (x + 2) := sorry 

theorem even_or_odd_alternates (x : Int) :
  even_or_odd x ≠ even_or_odd (x + 1) := sorry

theorem even_or_odd_negation (x : Int) :
  even_or_odd x = even_or_odd (-x) := sorry
