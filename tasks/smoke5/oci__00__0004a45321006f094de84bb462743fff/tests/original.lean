-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsZigzag_precond (sequence : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsZigzag (sequence : List Int) (h_precond : IsZigzag_precond sequence) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isZigzagProp (seq : List Int) : Prop :=
  seq.length ≥ 2 ∧
  -- All consecutive differences are nonzero
  (∀ i, i + 1 < seq.length → seq[i + 1]! ≠ seq[i]!) ∧
  -- Consecutive differences alternate in sign
  (∀ i, i + 2 < seq.length →
    (seq[i + 1]! - seq[i]!) * (seq[i + 2]! - seq[i + 1]!) < 0)
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsZigzag_postcond (sequence : List Int) (result : Bool) (h_precond : IsZigzag_precond sequence) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ isZigzagProp sequence
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsZigzag_spec_satisfied (sequence : List Int) (h_precond : IsZigzag_precond sequence) :
    IsZigzag_postcond sequence (IsZigzag sequence h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof