import Mathlib

def isValid (formula : List Nat) : Bool := sorry

theorem valid_formula_characterization (formula : List Nat) :
  isValid formula = ¬(
    ((1 ∈ formula) ∧ (2 ∈ formula)) ∨
    ((3 ∈ formula) ∧ (4 ∈ formula)) ∨
    ((5 ∈ formula) ∧ (6 ∉ formula)) ∨
    ((6 ∈ formula) ∧ (5 ∉ formula)) ∨
    ((7 ∉ formula) ∧ (8 ∉ formula))
  ) := sorry

theorem out_of_range_elements (formula : List Nat) :
  (∀ x ∈ formula, x < 1 ∨ x > 8) →
  isValid formula = isValid [] := sorry
