-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPermutation_precond (arr1 : List Int) (arr2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPermutation (arr1 : List Int) (arr2 : List Int)
    (h_precond : IsPermutation_precond arr1 arr2) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPermutation_postcond (arr1 : List Int) (arr2 : List Int) (result : Bool)
    (h_precond : IsPermutation_precond arr1 arr2) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ arr2.Perm arr1
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPermutation_spec_satisfied (arr1 : List Int) (arr2 : List Int)
    (h_precond : IsPermutation_precond arr1 arr2) :
    IsPermutation_postcond arr1 arr2 (IsPermutation arr1 arr2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof