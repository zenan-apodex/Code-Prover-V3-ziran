-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def mergeSortedLists_precond (arr1 : List Int) (arr2 : List Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (· ≤ ·) arr1 ∧ List.Pairwise (· ≤ ·) arr2
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def mergeSortedLists (arr1 : List Int) (arr2 : List Int) (h_precond : mergeSortedLists_precond (arr1) (arr2)) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def mergeSortedLists_postcond (arr1 : List Int) (arr2 : List Int) (result: List Int) (h_precond : mergeSortedLists_precond (arr1) (arr2)) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (· ≤ ·) result ∧ List.isPerm (arr1 ++ arr2) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem mergeSortedLists_spec_satisfied (arr1: List Int) (arr2: List Int) (h_precond : mergeSortedLists_precond (arr1) (arr2)) :
    mergeSortedLists_postcond (arr1) (arr2) (mergeSortedLists (arr1) (arr2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


