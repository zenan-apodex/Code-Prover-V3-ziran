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


def LengthOfLis (nums : List Int) (h_precond : LengthOfLis_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list of natural numbers `indices` represents a valid strictly increasing subsequence
    of `nums` if the indices are strictly increasing and the values at those indices are
    strictly increasing. -/
def IsStrictlyIncreasingSubseq (nums : List Int) (indices : List Nat) : Prop :=
  -- All indices are in bounds
  (∀ i, i ∈ indices → i < nums.length) ∧
  -- Indices are strictly increasing
  List.Pairwise (· < ·) indices ∧
  -- Values at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (fun i => nums[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Int) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  -- result is non-negative
  result ≥ 0 ∧
  -- There exists a strictly increasing subsequence of length `result`
  (∃ indices : List Nat, IsStrictlyIncreasingSubseq nums indices ∧ indices.length = result.toNat) ∧
  -- No strictly increasing subsequence has length greater than `result`
  (∀ indices : List Nat, IsStrictlyIncreasingSubseq nums indices → (indices.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof