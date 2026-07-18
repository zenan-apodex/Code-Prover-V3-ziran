-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveDuplicatesPreserveOrder_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RemoveDuplicatesPreserveOrder (lst : List Int)
    (h_precond : RemoveDuplicatesPreserveOrder_precond lst) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def RemoveDuplicatesPreserveOrder_postcond (lst : List Int) (result : List Int)
    (h_precond : RemoveDuplicatesPreserveOrder_precond lst) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
  (∀ x : Int, x ∈ result ↔ x ∈ lst) ∧
  List.Pairwise (fun a b => lst.idxOf a < lst.idxOf b) result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RemoveDuplicatesPreserveOrder_spec_satisfied (lst : List Int)
    (h_precond : RemoveDuplicatesPreserveOrder_precond lst) :
    RemoveDuplicatesPreserveOrder_postcond lst
      (RemoveDuplicatesPreserveOrder lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof