import Mathlib

def greet (name : Option String) : Option String := sorry

theorem greet_with_name (name : String) :
  greet (some name) = some s!"hello {name}!" := sorry

theorem greet_with_none :
  greet none = none := sorry
