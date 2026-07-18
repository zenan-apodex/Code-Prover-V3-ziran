-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def majorityElement_precond (xs : List Nat) : Prop :=
  -- !benchmark @start precond
  xs.length > 0 ∧ xs.any (fun x => xs.count x > xs.length / 2)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def majorityElement (xs : List Nat) (h_precond : majorityElement_precond (xs)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def majorityElement_postcond (xs : List Nat) (result: Nat) (h_precond : majorityElement_precond (xs)) : Prop :=
  -- !benchmark @start postcond
  let count := xs.count result
  count > xs.length / 2
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem majorityElement_spec_satisfied (xs: List Nat) (h_precond : majorityElement_precond (xs)) :
    majorityElement_postcond (xs) (majorityElement (xs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


