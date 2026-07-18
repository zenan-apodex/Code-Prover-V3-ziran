import Mathlib

def combat (health damage : Int) : Int := sorry

theorem combat_positive_inputs (health damage : Int) 
  (h₁ : health ≥ 0) (h₂ : damage ≥ 0) : 
  combat health damage = max 0 (health - damage) ∧ 
  combat health damage ≥ 0 := 
  sorry
