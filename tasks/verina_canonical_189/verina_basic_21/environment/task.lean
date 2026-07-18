-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def isSublist_precond (sub : List Int) (main : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def isSublist (sub : List Int) (main : List Int) (h_precond : isSublist_precond (sub) (main)) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def isSublist_postcond (sub : List Int) (main : List Int) (result: Bool) (h_precond : isSublist_precond (sub) (main)) :=
  -- !benchmark @start postcond
  (∃ i, i + sub.length ≤ main.length ∧ sub = (main.drop i).take sub.length) ↔ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem isSublist_spec_satisfied (sub: List Int) (main: List Int) (h_precond : isSublist_precond (sub) (main)) :
    isSublist_postcond (sub) (main) (isSublist (sub) (main) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
