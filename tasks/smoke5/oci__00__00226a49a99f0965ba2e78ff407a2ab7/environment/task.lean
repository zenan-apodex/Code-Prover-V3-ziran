-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MergeSortDescending_precond (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MergeSortDescending (arr : Array Int) (h_precond : MergeSortDescending_precond arr) : Array Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPermutation (a b : Array Int) : Prop :=
  a.toList.Perm b.toList

def isDescending (a : Array Int) : Prop :=
  ∀ i j : Nat, i < j → j < a.size → a[i]! ≥ a[j]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def MergeSortDescending_postcond (arr : Array Int) (result : Array Int) (h_precond : MergeSortDescending_precond arr) : Prop :=
  -- !benchmark @start postcond
  isPermutation arr result ∧ isDescending result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MergeSortDescending_spec_satisfied (arr : Array Int) (h_precond : MergeSortDescending_precond arr) :
    MergeSortDescending_postcond arr (MergeSortDescending arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof