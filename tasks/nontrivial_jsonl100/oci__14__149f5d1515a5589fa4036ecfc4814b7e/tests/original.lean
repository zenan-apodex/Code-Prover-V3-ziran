-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def FindLongestIncreasingSubsequence_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def FindLongestIncreasingSubsequence (arr : List Int) (h_precond : FindLongestIncreasingSubsequence_precond arr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list of indices `idxs` forms a valid strictly increasing subsequence of `arr`
    if the indices are strictly increasing and the values at those indices are strictly increasing. -/
def IsIncreasingSubseqIndices (arr : List Int) (idxs : List Nat) : Prop :=
  -- all indices are in bounds
  (∀ i ∈ idxs, i < arr.length) ∧
  -- indices are strictly increasing
  List.Pairwise (· < ·) idxs ∧
  -- values at those indices are strictly increasing
  List.Pairwise (· < ·) (idxs.map (fun i => arr[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindLongestIncreasingSubsequence_postcond (arr : List Int) (result : Int) (h_precond : FindLongestIncreasingSubsequence_precond arr) : Prop :=
  -- !benchmark @start postcond
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists an increasing subsequence of length `result`
  (∃ idxs : List Nat, IsIncreasingSubseqIndices arr idxs ∧ idxs.length = result.toNat) ∧
  -- no increasing subsequence is longer than `result`
  (∀ idxs : List Nat, IsIncreasingSubseqIndices arr idxs → (idxs.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem FindLongestIncreasingSubsequence_spec_satisfied (arr : List Int) (h_precond : FindLongestIncreasingSubsequence_precond arr) :
    FindLongestIncreasingSubsequence_postcond arr (FindLongestIncreasingSubsequence arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof