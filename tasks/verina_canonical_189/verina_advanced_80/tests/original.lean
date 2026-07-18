-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def twoSum_precond (nums : Array Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  -- The array must have at least 2 elements
  nums.size ≥ 2 ∧

  -- There exists exactly one pair of indices whose values sum to the target
  (List.range nums.size).any (fun i =>
    (List.range i).any (fun j => nums[i]! + nums[j]! = target)) ∧

  -- No other pair sums to the target (ensuring uniqueness of solution)
  ((List.range nums.size).flatMap (fun i =>
    (List.range i).filter (fun j => nums[i]! + nums[j]! = target))).length = 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def twoSum (nums : Array Int) (target : Int) (h_precond : twoSum_precond (nums) (target)) : Array Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def twoSum_postcond (nums : Array Int) (target : Int) (result: Array Nat) (h_precond : twoSum_precond (nums) (target)) : Prop :=
  -- !benchmark @start postcond
  -- Result contains exactly 2 indices
  result.size = 2 ∧

  -- The indices are valid (within bounds of the nums array)
  result[0]! < nums.size ∧ result[1]! < nums.size ∧

  -- The indices are in ascending order (sorted)
  result[0]! < result[1]! ∧

  -- The values at these indices sum to the target
  nums[result[0]!]! + nums[result[1]!]! = target
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem twoSum_spec_satisfied (nums: Array Int) (target: Int) (h_precond : twoSum_precond (nums) (target)) :
    twoSum_postcond (nums) (target) (twoSum (nums) (target) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


