-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def longestIncreasingStreak_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def longestIncreasingStreak (nums : List Int) (h_precond : longestIncreasingStreak_precond (nums)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def longestIncreasingStreak_postcond (nums : List Int) (result: Nat) (h_precond : longestIncreasingStreak_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  -- Case 1: Empty list means result = 0
  (nums = [] → result = 0) ∧

  -- Case 2: If result > 0, there exists a streak of exactly that length
  (result > 0 →
    (List.range (nums.length - result + 1) |>.any (fun start =>
      -- Check bounds are valid
      start + result ≤ nums.length ∧
      -- Check all consecutive pairs in this streak are increasing
      (List.range (result - 1) |>.all (fun i =>
        nums[start + i]! < nums[start + i + 1]!)) ∧
      -- Check this streak can't be extended left (if possible)
      (start = 0 ∨ nums[start - 1]! ≥ nums[start]!) ∧
      -- Check this streak can't be extended right (if possible)
      (start + result = nums.length ∨ nums[start + result - 1]! ≥ nums[start + result]!)))) ∧

  -- Case 3: No streak longer than result exists
  (List.range (nums.length - result) |>.all (fun start =>
    List.range result |>.any (fun i =>
      start + i + 1 ≥ nums.length ∨ nums[start + i]! ≥ nums[start + i + 1]!)))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem longestIncreasingStreak_spec_satisfied (nums: List Int) (h_precond : longestIncreasingStreak_precond (nums)) :
    longestIncreasingStreak_postcond (nums) (longestIncreasingStreak (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


