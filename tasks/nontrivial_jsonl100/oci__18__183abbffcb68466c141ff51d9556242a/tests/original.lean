-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestConsecutiveSubsequence_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestConsecutiveSubsequence (nums : List Int) (h_precond : LongestConsecutiveSubsequence_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A consecutive run starting at `start` of length `len` means every integer
    in `{start, start+1, ..., start+len-1}` belongs to the set of `nums`. -/
def isConsecutiveRun (nums : List Int) (start : Int) (len : Nat) : Prop :=
  ∀ k : Nat, k < len → (start + ↑k) ∈ nums
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestConsecutiveSubsequence_postcond (nums : List Int) (result : Int) (h_precond : LongestConsecutiveSubsequence_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists a consecutive run of length `result`
  (∃ start : Int, isConsecutiveRun nums start result.toNat) ∧
  -- No consecutive run is longer than `result`
  (∀ start : Int, ∀ len : Nat, isConsecutiveRun nums start len → (len : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestConsecutiveSubsequence_spec_satisfied (nums : List Int) (h_precond : LongestConsecutiveSubsequence_precond nums) :
    LongestConsecutiveSubsequence_postcond nums (LongestConsecutiveSubsequence nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof