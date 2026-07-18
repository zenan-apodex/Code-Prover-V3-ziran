-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LengthOfLis_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLis (arr : List Int) (h_precond : LengthOfLis_precond arr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsIncreasingSubseq indices arr` means `indices` is a strictly increasing
    list of valid indices into `arr`, and the values at those indices are
    strictly increasing. -/
def IsIncreasingSubseq (indices : List Nat) (arr : List Int) : Prop :=
  -- all indices are valid
  (∀ i ∈ indices, i < arr.length) ∧
  -- indices are strictly increasing (preserves order)
  List.Pairwise (· < ·) indices ∧
  -- values at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (fun i => arr[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (arr : List Int) (result : Int) (h_precond : LengthOfLis_precond arr) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists an increasing subsequence of this length
  (∃ indices : List Nat, IsIncreasingSubseq indices arr ∧ indices.length = result.toNat) ∧
  -- No increasing subsequence is longer
  (∀ indices : List Nat, IsIncreasingSubseq indices arr → (indices.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (arr : List Int) (h_precond : LengthOfLis_precond arr) :
    LengthOfLis_postcond arr (LengthOfLis arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof