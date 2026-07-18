import Mathlib

/-- The function that returns the type name of a given value -/
def types (x : α) : String := sorry

/-- For any given value, the types function returns a string that should be consistent -/
theorem types_matches_type_name {α : Type} (x : α) :
  types x = types x := sorry

/-- The types function is reflexive -/
theorem types_preserves_equality {α : Type} (x : α) :
  types x = types x := sorry
