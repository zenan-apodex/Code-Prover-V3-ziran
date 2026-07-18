-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- (helper defs used by the implementation; leave block empty — Stage 1
-- does not emit an impl)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- (helper defs used by the precondition; leave block empty if none)
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMax_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- (leave empty — Stage 1 does not emit an impl)
-- !benchmark @end code_aux


def FindMax (lst : List Int) (h_precond : FindMax_precond lst) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- (helper defs used by the postcondition; leave block empty if none)
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindMax_postcond (lst : List Int) (result : Option Int) (h_precond : FindMax_precond lst) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => lst = []
  | some m => m ∈ lst ∧ ∀ x, x ∈ lst → x ≤ m
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindMax_spec_satisfied (lst : List Int) (h_precond : FindMax_precond lst) :
    FindMax_postcond lst (FindMax lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof