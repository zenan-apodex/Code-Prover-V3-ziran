import Mathlib

def even_numbers_before_fixed (sequence : List Int) (fixed : Int) : Int :=
  sorry

theorem not_found_returns_neg_one (sequence : List Int) (fixed : Int) : 
  ¬(fixed ∈ sequence) → even_numbers_before_fixed sequence fixed = -1 :=
  sorry

theorem count_evens_before_first_occurrence (sequence : List Int) (fixed : Int) :
  fixed ∈ sequence →
  even_numbers_before_fixed sequence fixed = 
    ((sequence.take (sequence.findIdx (· = fixed))).filter (·.mod 2 = 0)).length :=
  sorry

theorem result_is_nonneg_when_found (sequence : List Int) (fixed : Int) :
  fixed ∈ sequence →
  even_numbers_before_fixed sequence fixed ≥ 0 :=
  sorry
