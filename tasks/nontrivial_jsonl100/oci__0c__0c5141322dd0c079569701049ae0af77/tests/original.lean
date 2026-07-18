-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LengthOfLis_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLis (nums : List Int) (h_precond : LengthOfLis_precond nums) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsIncreasingSubseq nums indices` means `indices` is a strictly increasing
    list of valid indices into `nums` such that the values at those indices
    are strictly increasing. -/
def IsIncreasingSubseq (nums : List Int) (indices : List Nat) : Prop :=
  -- all indices are valid
  (∀ i ∈ indices, i < nums.length) ∧
  -- indices are strictly increasing
  List.Pairwise (· < ·) indices ∧
  -- values at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (nums[·]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Nat) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  -- There exists an increasing subsequence of length `result`
  (∃ indices : List Nat, indices.length = result ∧ IsIncreasingSubseq nums indices) ∧
  -- No increasing subsequence is longer than `result`
  (∀ indices : List Nat, IsIncreasingSubseq nums indices → indices.length ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof