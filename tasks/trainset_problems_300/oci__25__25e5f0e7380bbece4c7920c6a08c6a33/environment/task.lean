-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ComputeSum_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ComputeSum (numbers : List Int) (h_precond : ComputeSum_precond numbers) : Float :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def ComputeSum_postcond (numbers : List Int) (result : Float)
    (h_precond : ComputeSum_precond numbers) : Prop :=
  -- !benchmark @start postcond
  result = Float.ofInt (numbers.sum)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ComputeSum_spec_satisfied (numbers : List Int)
    (h_precond : ComputeSum_precond numbers) :
    ComputeSum_postcond numbers (ComputeSum numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof