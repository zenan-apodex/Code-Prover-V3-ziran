-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def UniqueElementsPreserveOrder_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def UniqueElementsPreserveOrder (lst : List Int)
    (h_precond : UniqueElementsPreserveOrder_precond lst) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def UniqueElementsPreserveOrder_postcond (lst : List Int) (result : List Int)
    (h_precond : UniqueElementsPreserveOrder_precond lst) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
  (∀ x : Int, x ∈ result ↔ x ∈ lst) ∧
  (∀ x y : Int, x ∈ result → y ∈ result →
    (result.idxOf x < result.idxOf y ↔ lst.idxOf x < lst.idxOf y))
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem UniqueElementsPreserveOrder_spec_satisfied (lst : List Int)
    (h_precond : UniqueElementsPreserveOrder_precond lst) :
    UniqueElementsPreserveOrder_postcond lst
      (UniqueElementsPreserveOrder lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof