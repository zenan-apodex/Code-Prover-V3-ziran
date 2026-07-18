-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Quicksort_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def Quicksort (arr : List Int) (h_precond : Quicksort_precond arr) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def Quicksort_postcond (arr : List Int) (result : List Int)
    (h_precond : Quicksort_precond arr) : Prop :=
  -- !benchmark @start postcond
  result.Perm arr ∧ List.Pairwise (fun a b => a ≤ b) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Quicksort_spec_satisfied (arr : List Int) (h_precond : Quicksort_precond arr) :
    Quicksort_postcond arr (Quicksort arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof