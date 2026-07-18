import Mathlib

def parse_float (s : String) : Option Float := sorry 

theorem parse_valid_float (f : Float) : 
  parse_float (toString f) = some f := sorry

theorem parse_invalid_string {s : String} :
  (∀ f : Float, toString f ≠ s) → parse_float s = none := sorry 

theorem parse_empty_string :
  parse_float "" = none := sorry
