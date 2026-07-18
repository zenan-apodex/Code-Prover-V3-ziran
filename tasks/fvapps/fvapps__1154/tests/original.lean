import Mathlib

def find_imposter (n : Nat) (base : List Int) (game : List Int) : Int :=
  sorry

theorem find_imposter_correct (base : List Int) (imposter : Int) :
  imposter ∉ base →  -- assume imposter not in base list
  find_imposter (base.length) base (base ++ [imposter]) = imposter := by  
  sorry
