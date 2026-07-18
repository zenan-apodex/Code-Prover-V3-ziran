import Mathlib

def max_satisfaction (satisfaction : List Int) : Int :=
  sorry

theorem max_satisfaction_nonnegative
  (satisfaction : List Int) :
  max_satisfaction satisfaction ≥ 0 :=
  sorry

theorem max_satisfaction_empty :
  max_satisfaction [] = 0 :=
  sorry



theorem max_satisfaction_single_zero :
  max_satisfaction [0] = 0 :=
  sorry

theorem max_satisfaction_single_positive :
  max_satisfaction [1] = 1 :=
  sorry

theorem max_satisfaction_single_negative :
  max_satisfaction [-1] = 0 :=
  sorry
