-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def uniqueSorted_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def uniqueSorted (arr : List Int) (h_precond : uniqueSorted_precond (arr)) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def uniqueSorted_postcond (arr : List Int) (result: List Int) (h_precond : uniqueSorted_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  List.isPerm arr.eraseDups result ∧ List.Pairwise (· ≤ ·) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem uniqueSorted_spec_satisfied (arr: List Int) (h_precond : uniqueSorted_precond (arr)) :
    uniqueSorted_postcond (arr) (uniqueSorted (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


