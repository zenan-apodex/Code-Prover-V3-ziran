-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def lastPosition_precond (arr : Array Int) (elem : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (· ≤ ·) arr.toList
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def lastPosition (arr : Array Int) (elem : Int) (h_precond : lastPosition_precond (arr) (elem)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def lastPosition_postcond (arr : Array Int) (elem : Int) (result: Int) (h_precond : lastPosition_precond (arr) (elem)) :=
  -- !benchmark @start postcond
  (result = -1 ∨ result ≥ 0) ∧
  (result ≥ 0 →
    result.toNat < arr.size ∧
    arr[result.toNat]! = elem ∧ (arr.toList.drop (result.toNat + 1)).all (· ≠ elem)) ∧
  (result = -1 → arr.toList.all (· ≠ elem))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem lastPosition_spec_satisfied (arr: Array Int) (elem: Int) (h_precond : lastPosition_precond (arr) (elem)) :
    lastPosition_postcond (arr) (elem) (lastPosition (arr) (elem) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
