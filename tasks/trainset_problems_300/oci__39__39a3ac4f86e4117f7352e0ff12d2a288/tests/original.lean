-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MergeSortedArrays_precond (arr1 : List Int) (arr2 : List Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≤ b) arr1 ∧
  List.Pairwise (fun a b => a ≤ b) arr2
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MergeSortedArrays (arr1 : List Int) (arr2 : List Int)
    (h_precond : MergeSortedArrays_precond arr1 arr2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MergeSortedArrays_postcond (arr1 : List Int) (arr2 : List Int) (result : List Int)
    (h_precond : MergeSortedArrays_precond arr1 arr2) : Prop :=
  -- !benchmark @start postcond
  result.Perm (arr1 ++ arr2) ∧
  List.Pairwise (fun a b => a ≤ b) result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MergeSortedArrays_spec_satisfied (arr1 : List Int) (arr2 : List Int)
    (h_precond : MergeSortedArrays_precond arr1 arr2) :
    MergeSortedArrays_postcond arr1 arr2 (MergeSortedArrays arr1 arr2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof