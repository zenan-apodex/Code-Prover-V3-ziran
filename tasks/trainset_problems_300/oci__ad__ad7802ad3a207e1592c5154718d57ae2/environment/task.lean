-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CanCollectAllItems_precond (item_weights : List Int) (max_capacity : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CanCollectAllItems (item_weights : List Int) (max_capacity : Int)
    (h_precond : CanCollectAllItems_precond item_weights max_capacity) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CanCollectAllItems_postcond (item_weights : List Int) (max_capacity : Int)
    (result : Bool) (h_precond : CanCollectAllItems_precond item_weights max_capacity) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ item_weights.sum ≤ max_capacity
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CanCollectAllItems_spec_satisfied (item_weights : List Int) (max_capacity : Int)
    (h_precond : CanCollectAllItems_precond item_weights max_capacity) :
    CanCollectAllItems_postcond item_weights max_capacity
      (CanCollectAllItems item_weights max_capacity h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof