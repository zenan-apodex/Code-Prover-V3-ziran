import Mathlib

inductive Op where
  | add
  | subtract
  | multiply
  | divide
  deriving Repr

def arithmetic (a b : Int) (op : Op) : Int :=
  sorry

theorem arithmetic_add (a b : Int) : 
  arithmetic a b Op.add = a + b := sorry

theorem arithmetic_subtract (a b : Int) :
  arithmetic a b Op.subtract = a - b := sorry

theorem arithmetic_multiply (a b : Int) :
  arithmetic a b Op.multiply = a * b := sorry

theorem arithmetic_divide (a b : Int) (h : b ≠ 0) :
  arithmetic a b Op.divide = a / b := sorry
