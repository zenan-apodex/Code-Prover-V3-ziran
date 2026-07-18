import Mathlib

def name_score (name : String) (alpha : Option (Lean.HashMap String Int) := none) : 
  Lean.HashMap String Int := sorry

theorem name_score_returns_dict_with_name (name : String) :
  let result := name_score name
  result.size = 1 ∧ result.contains name := sorry

theorem name_score_with_custom_alpha (name : String) (alpha : Lean.HashMap String Int) :
  let result := name_score name (some alpha)
  result.size = 1 ∧ result.contains name := sorry

theorem name_score_case_insensitive (name : String) : 
  (name_score name.toLower).find! name.toLower = 
  (name_score name.toUpper).find! name.toUpper := sorry

theorem name_score_nonnegative (name : String) :
  (name_score name).find! name ≥ 0 := sorry

theorem name_score_additive (name1 name2 : String) :
  (name_score (name1 ++ name2)).find! (name1 ++ name2) = 
  (name_score name1).find! name1 + (name_score name2).find! name2 := sorry
