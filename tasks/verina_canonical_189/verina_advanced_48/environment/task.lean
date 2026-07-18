-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def mergeSort_precond (list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def mergeSort (list : List Int) (h_precond : mergeSort_precond (list)) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def mergeSort_postcond (list : List Int) (result: List Int) (h_precond : mergeSort_precond (list)) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (· ≤ ·) result ∧ List.isPerm list result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem mergeSort_spec_satisfied (list: List Int) (h_precond : mergeSort_precond (list)) :
    mergeSort_postcond (list) (mergeSort (list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


