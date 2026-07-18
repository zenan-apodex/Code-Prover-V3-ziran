-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def HasDuplicates_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def HasDuplicates (lst : List Int) (h_precond : HasDuplicates_precond lst) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def HasDuplicateProp (lst : List Int) : Prop :=
  ∃ i j : Nat, i < lst.length ∧ j < lst.length ∧ i < j ∧ lst[i]! = lst[j]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def HasDuplicates_postcond (lst : List Int) (result : Bool)
    (h_precond : HasDuplicates_precond lst) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ HasDuplicateProp lst
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem HasDuplicates_spec_satisfied (lst : List Int)
    (h_precond : HasDuplicates_precond lst) :
    HasDuplicates_postcond lst (HasDuplicates lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof