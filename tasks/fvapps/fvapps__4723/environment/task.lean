import Mathlib

def greet (name : String) : String := sorry

theorem greet_starts_with_hello (name : String) (h : name.length > 0) :
  (greet name).startsWith "Hello " = true := sorry

theorem greet_ends_with_exclamation (name : String) (h : name.length > 0) :
  (greet name).endsWith "!" = true := sorry

theorem greet_contains_capitalized_name (name : String) (h : name.length > 0) :
  ((greet name).drop "Hello ".length).dropRight 1 = name.capitalize := sorry
