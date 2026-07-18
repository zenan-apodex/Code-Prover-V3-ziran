import Mathlib

def VALID_FIGHTERS := ["george saint pierre", "conor mcgregor"]

def quote (fighter : String) : String :=
  sorry

theorem quote_case_insensitive (fighter : String)
  (h : fighter.toLower ∈ VALID_FIGHTERS) :
  ∀ casing, quote casing = quote fighter →
  casing.toLower = fighter.toLower :=
sorry

theorem quote_invalid_fighter (fighter : String) :
  fighter.toLower ∉ VALID_FIGHTERS → 
  ∀ result, ¬(quote fighter = result) :=
sorry

theorem non_matching_fighter_raises (invalid_name : String) :
  invalid_name.toLower ∉ VALID_FIGHTERS →
  ∀ result, ¬(quote invalid_name = result) := 
sorry
