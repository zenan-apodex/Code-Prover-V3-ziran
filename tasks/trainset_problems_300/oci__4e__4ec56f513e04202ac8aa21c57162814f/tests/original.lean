-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def HighestScoreExcludingOne_precond (scores : List Int) : Prop :=
  -- !benchmark @start precond
  scores.length ≥ 2
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def HighestScoreExcludingOne (scores : List Int)
    (h_precond : HighestScoreExcludingOne_precond scores) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def HighestScoreExcludingOne_postcond (scores : List Int) (result : Int)
    (h_precond : HighestScoreExcludingOne_precond scores) : Prop :=
  -- !benchmark @start postcond
  ∃ M : Int,
    M ∈ scores ∧
    (∀ x : Int, x ∈ scores → x ≤ M) ∧
    (
      (2 ≤ scores.count M ∧ result = M) ∨
      (scores.count M = 1 ∧
        result ∈ scores ∧
        result < M ∧
        ∀ x : Int, x ∈ scores → x ≠ M → x ≤ result)
    )
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem HighestScoreExcludingOne_spec_satisfied (scores : List Int)
    (h_precond : HighestScoreExcludingOne_precond scores) :
    HighestScoreExcludingOne_postcond scores (HighestScoreExcludingOne scores h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof