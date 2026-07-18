-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestConsecutiveSequence_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestConsecutiveSequence (nums : List Int) (h_precond : LongestConsecutiveSequence_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A consecutive run of length `len` starting at `start` is contained in `nums` -/
def isConsecutiveRun (nums : List Int) (start : Int) (len : Nat) : Prop :=
  ∀ i : Nat, i < len → (start + ↑i) ∈ nums

-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestConsecutiveSequence_postcond (nums : List Int) (result : Int) (h_precond : LongestConsecutiveSequence_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- If nums is empty, result is 0
  (nums = [] → result = 0) ∧
  -- If nums is nonempty, result is at least 1
  (nums ≠ [] → result ≥ 1) ∧
  -- There exists a consecutive run of length result.toNat in nums
  (∃ start : Int, isConsecutiveRun nums start result.toNat) ∧
  -- No consecutive run of length result.toNat + 1 exists in nums
  (∀ start : Int, ¬ isConsecutiveRun nums start (result.toNat + 1))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestConsecutiveSequence_spec_satisfied (nums : List Int) (h_precond : LongestConsecutiveSequence_precond nums) :
    LongestConsecutiveSequence_postcond nums (LongestConsecutiveSequence nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof