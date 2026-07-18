-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LengthOfLis_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLis (numbers : List Int) (h_precond : LengthOfLis_precond numbers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A strictly increasing subsequence of `numbers` is represented by a list of indices
    that is strictly increasing, all within bounds, and whose corresponding elements
    are strictly increasing. -/
def IsStrictlyIncreasingSubseqIndices (numbers : List Int) (indices : List Nat) : Prop :=
  -- all indices are in bounds
  (∀ i ∈ indices, i < numbers.length) ∧
  -- indices are strictly increasing
  List.Pairwise (· < ·) indices ∧
  -- elements at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (fun i => numbers[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (numbers : List Int) (result : Int) (h_precond : LengthOfLis_precond numbers) : Prop :=
  -- !benchmark @start postcond
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a strictly increasing subsequence of that length
  (∃ indices : List Nat,
    IsStrictlyIncreasingSubseqIndices numbers indices ∧
    indices.length = result.toNat) ∧
  -- no strictly increasing subsequence is longer
  (∀ indices : List Nat,
    IsStrictlyIncreasingSubseqIndices numbers indices →
    (indices.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (numbers : List Int) (h_precond : LengthOfLis_precond numbers) :
    LengthOfLis_postcond numbers (LengthOfLis numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof