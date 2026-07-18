import Mathlib

structure CharAttribute where
  modifier : Int
  maximum_spell_level : Int
  extra_spells : List Int
deriving Repr

def char_attribute : Int → CharAttribute := sorry

theorem char_attribute_types (score : Int) :
  let result := char_attribute score
  0 ≤ score → score ≤ 100 →
  True := sorry

theorem max_spell_level_constraints (score : Int) :
  let result := char_attribute score
  0 ≤ score → score ≤ 100 →
  (score = 0 → result.maximum_spell_level = -1) ∧
  (score ≠ 0 → 
    let modifier := score / 2 - 5
    result.maximum_spell_level ≤ 9 ∧
    (modifier < 0 → result.maximum_spell_level = -1) ∧
    (score ≥ 10 → result.maximum_spell_level ≤ score - 10)) := sorry

theorem extra_spells_properties (score : Int) :
  let result := char_attribute score 
  0 ≤ score → score ≤ 100 →
  result.extra_spells.length ≤ 9 ∧
  (∀ x ∈ result.extra_spells, x > 0) ∧
  (∀ i j, i < j → j < result.extra_spells.length → 
    match result.extra_spells.get? i, result.extra_spells.get? j with
    | some x, some y => x ≥ y
    | _, _ => true) := sorry
