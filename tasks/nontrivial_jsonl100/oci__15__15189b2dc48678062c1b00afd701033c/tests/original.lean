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
  nums.length ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLis (nums : List Int) (h_precond : LengthOfLis_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsStrictlyIncreasingSubseq indices nums` means that `indices` is a strictly increasing
    list of valid indices into `nums`, and the values at those indices are strictly increasing. -/
def IsStrictlyIncreasingSubseq (indices : List Nat) (nums : List Int) : Prop :=
  -- indices are strictly increasing (hence distinct)
  List.Pairwise (· < ·) indices ∧
  -- all indices are valid
  (∀ i ∈ indices, i < nums.length) ∧
  -- the values at those indices are strictly increasing
  List.Pairwise (· < ·) (indices.map (fun i => nums[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Int) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 1 ∧
  -- There exists a strictly increasing subsequence of this length
  (∃ indices : List Nat, IsStrictlyIncreasingSubseq indices nums ∧ indices.length = result.toNat) ∧
  -- No strictly increasing subsequence is longer
  (∀ indices : List Nat, IsStrictlyIncreasingSubseq indices nums → (indices.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof