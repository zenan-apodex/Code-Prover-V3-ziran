-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def Nondecreasing (xs : List Int) : Prop :=
  List.Pairwise (fun a b => a ≤ b) xs
-- !benchmark @end precond_aux

@[reducible, simp]
def MergeSortedLists_precond (list1 : List Int) (list2 : List Int) : Prop :=
  -- !benchmark @start precond
  Nondecreasing list1 ∧ Nondecreasing list2
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MergeSortedLists (list1 : List Int) (list2 : List Int)
    (h_precond : MergeSortedLists_precond list1 list2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MergeSortedLists_postcond (list1 : List Int) (list2 : List Int) (result : List Int)
    (h_precond : MergeSortedLists_precond list1 list2) : Prop :=
  -- !benchmark @start postcond
  result.Perm (list1 ++ list2) ∧ Nondecreasing result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MergeSortedLists_spec_satisfied (list1 : List Int) (list2 : List Int)
    (h_precond : MergeSortedLists_precond list1 list2) :
    MergeSortedLists_postcond list1 list2 (MergeSortedLists list1 list2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof