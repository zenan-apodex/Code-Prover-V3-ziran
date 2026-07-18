-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindIndexOfMaxValue_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindIndexOfMaxValue (arr : List Int) (h_precond : FindIndexOfMaxValue_precond arr) : Option Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindIndexOfMaxValue_postcond (arr : List Int) (result : Option Nat)
    (h_precond : FindIndexOfMaxValue_precond arr) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => arr = []
  | some idx =>
      idx < arr.length ∧
      (∀ i : Nat, i < arr.length → arr[i]! ≤ arr[idx]!) ∧
      (∀ i : Nat, i < idx → arr[i]! < arr[idx]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindIndexOfMaxValue_spec_satisfied (arr : List Int)
    (h_precond : FindIndexOfMaxValue_precond arr) :
    FindIndexOfMaxValue_postcond arr (FindIndexOfMaxValue arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof