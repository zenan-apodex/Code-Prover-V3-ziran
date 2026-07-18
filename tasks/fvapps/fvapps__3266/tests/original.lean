import Mathlib

def my_first_kata (a b : Int) : Int ⊕ Bool := sorry

def string_kata (a : String) (b : Int) : Int ⊕ Bool := sorry 

theorem result_is_sum_of_mods {a b : Int} (h1 : b ≠ 0) (h2 : a ≠ 0) :
  my_first_kata a b = .inl (a % b + b % a) := sorry

theorem invalid_string_input {a : String} {b : Int} :
  string_kata a b = .inr false := sorry
