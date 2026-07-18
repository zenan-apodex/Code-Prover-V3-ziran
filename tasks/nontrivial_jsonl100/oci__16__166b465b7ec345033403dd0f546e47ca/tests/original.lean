-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestIncreasingSubsequence_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestIncreasingSubsequence (nums : List Int) (h_precond : LongestIncreasingSubsequence_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `indices` is a strictly increasing list of valid indices into `nums`,
    and the values at those indices form a strictly increasing sequence. -/
def IsIncreasingSubseqIndices (nums : List Int) (indices : List Nat) : Prop :=
  -- indices are strictly increasing
  List.Pairwise (· < ·) indices ∧
  -- all indices are valid
  (∀ i ∈ indices, i < nums.length) ∧
  -- values at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (fun i => nums[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestIncreasingSubsequence_postcond (nums : List Int) (result : Int) (h_precond : LongestIncreasingSubsequence_precond nums) : Prop :=
  -- !benchmark @start postcond
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists an increasing subsequence of length `result`
  (∃ indices : List Nat, IsIncreasingSubseqIndices nums indices ∧ indices.length = result.toNat) ∧
  -- no increasing subsequence has length greater than `result`
  (∀ indices : List Nat, IsIncreasingSubseqIndices nums indices → (indices.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestIncreasingSubsequence_spec_satisfied (nums : List Int) (h_precond : LongestIncreasingSubsequence_precond nums) :
    LongestIncreasingSubsequence_postcond nums (LongestIncreasingSubsequence nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof