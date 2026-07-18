-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CalculateAverageScores_precond (scores_dict : List (String × List Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) scores_dict
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CalculateAverageScores (scores_dict : List (String × List Int))
    (h_precond : CalculateAverageScores_precond scores_dict) : List (String × Float) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def AverageValueOfScores (scores : List Int) : Float :=
  if scores.length = 0 then
    0
  else
    Float.ofInt scores.sum / Float.ofNat scores.length
-- !benchmark @end postcond_aux


@[reducible, simp]
def CalculateAverageScores_postcond (scores_dict : List (String × List Int))
    (result : List (String × Float))
    (h_precond : CalculateAverageScores_precond scores_dict) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, ∃ scores, (p.1, scores) ∈ scores_dict ∧ p.2 = AverageValueOfScores scores) ∧
  (∀ name scores, (name, scores) ∈ scores_dict → ∃ avg, (name, avg) ∈ result) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CalculateAverageScores_spec_satisfied (scores_dict : List (String × List Int))
    (h_precond : CalculateAverageScores_precond scores_dict) :
    CalculateAverageScores_postcond scores_dict
      (CalculateAverageScores scores_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof