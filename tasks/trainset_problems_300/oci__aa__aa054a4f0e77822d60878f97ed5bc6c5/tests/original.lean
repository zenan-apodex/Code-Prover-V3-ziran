-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IterativeSum_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  n ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IterativeSum (n : Int) (h_precond : IterativeSum_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IterativeSum_postcond (n : Int) (result : Int) (h_precond : IterativeSum_precond n) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧ 2 * result = n * (n + 1)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IterativeSum_spec_satisfied (n : Int) (h_precond : IterativeSum_precond n) :
    IterativeSum_postcond n (IterativeSum n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof