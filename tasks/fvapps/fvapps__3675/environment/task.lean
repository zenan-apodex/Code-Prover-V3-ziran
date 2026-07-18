import Mathlib

def toBool (b : Bool) : Bool := b

def negation_value (s : String) (value : Bool) : Bool := sorry

theorem double_negation (value : Bool) :
  negation_value "!!" value = value := sorry

theorem basic_negation (value : Bool) :
  negation_value "!" value = !value := sorry

theorem empty_negation (value : Bool) : 
  negation_value "" value = value := sorry
