-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RotateArray_precond (arr : List Int) (k : Int) : Prop :=
  -- !benchmark @start precond
  arr.length > 0 ∧ 0 ≤ k
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RotateArray (arr : List Int) (k : Int) (h_precond : RotateArray_precond arr k) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def RotateArray_postcond (arr : List Int) (k : Int) (result : List Int)
    (h_precond : RotateArray_precond arr k) : Prop :=
  -- !benchmark @start postcond
  result.length = arr.length ∧
  ∀ i : Nat, i < arr.length →
    result[i]! = arr[((i + arr.length) - (Int.toNat k % arr.length)) % arr.length]!
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RotateArray_spec_satisfied (arr : List Int) (k : Int)
    (h_precond : RotateArray_precond arr k) :
    RotateArray_postcond arr k (RotateArray arr k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof