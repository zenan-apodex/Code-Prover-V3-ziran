-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ApplyOperations_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 1000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ApplyOperations (n : Int) (h_precond : ApplyOperations_precond n) : Int × Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def ApplyOperations_postcond (n : Int) (result : Int × Int)
    (h_precond : ApplyOperations_precond n) : Prop :=
  -- !benchmark @start postcond
  result.1 = 2 ∧ result.2 = 2 * n + 1
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ApplyOperations_spec_satisfied (n : Int)
    (h_precond : ApplyOperations_precond n) :
    ApplyOperations_postcond n (ApplyOperations n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof