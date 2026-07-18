-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RunningTotal_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RunningTotal (nums : List Int) (h_precond : RunningTotal_precond nums) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def RunningTotal_postcond (nums : List Int) (result : List Int)
    (h_precond : RunningTotal_precond nums) : Prop :=
  -- !benchmark @start postcond
  result.length = nums.length ∧
  ∀ i : Nat, i < result.length →
    result[i]! = (nums.take (i + 1)).sum
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RunningTotal_spec_satisfied (nums : List Int) (h_precond : RunningTotal_precond nums) :
    RunningTotal_postcond nums (RunningTotal nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof