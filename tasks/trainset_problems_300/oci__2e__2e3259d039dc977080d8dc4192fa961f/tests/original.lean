-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsUnique_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsUnique (s : String) (h_precond : IsUnique_precond s) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsUnique_postcond (s : String) (result : Bool) (h_precond : IsUnique_precond s) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ List.Pairwise (fun a b => a ≠ b) s.toList
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsUnique_spec_satisfied (s : String) (h_precond : IsUnique_precond s) :
    IsUnique_postcond s (IsUnique s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof