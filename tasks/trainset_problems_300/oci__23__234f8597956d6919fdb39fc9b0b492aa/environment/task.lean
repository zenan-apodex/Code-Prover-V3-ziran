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
def HasIncreasingSubseqOfLength (nums : List Int) (k : Nat) : Prop :=
  ∃ idxs : List Nat,
    idxs.length = k ∧
    (∀ i ∈ idxs, i < nums.length) ∧
    List.Pairwise (fun i j => i < j ∧ nums[i]! < nums[j]!) idxs
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Int) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  ∃ k : Nat,
    result = Int.ofNat k ∧
    HasIncreasingSubseqOfLength nums k ∧
    (∀ m : Nat, HasIncreasingSubseqOfLength nums m → m ≤ k)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof