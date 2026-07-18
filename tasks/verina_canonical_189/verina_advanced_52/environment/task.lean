-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def minOperations_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  let target_nums := (List.range k).map (· + 1)
  target_nums.all (fun n => List.elem n nums)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def minOperations (nums : List Nat) (k : Nat) (h_precond : minOperations_precond (nums) (k)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def minOperations_postcond (nums : List Nat) (k : Nat) (result: Nat) (h_precond : minOperations_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  -- define the list of elements processed after `result` operations
  let processed := (nums.reverse).take result
  -- define the target numbers to collect (1 to k)
  let target_nums := (List.range k).map (· + 1)

  -- condition 1: All target numbers must be present in the processed elements
  let collected_all := target_nums.all (fun n => List.elem n processed)

  -- condition 2: `result` must be the minimum number of operations.
  -- This means either result is 0 (which implies k must be 0 as target_nums would be empty)
  -- or result > 0, and taking one less operation (result - 1) is not sufficient
  let is_minimal :=
    if result > 0 then
      -- if one fewer element is taken, not all target numbers should be present
      let processed_minus_one := (nums.reverse).take (result - 1)
      ¬ (target_nums.all (fun n => List.elem n processed_minus_one))
    else
      -- if result is 0, it can only be minimal if k is 0 (no targets required)
      -- So if k=0, `collected_all` is true. If result=0, this condition `k==0` ensures minimality.
      k == 0

  -- overall specification:
  collected_all ∧ is_minimal
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem minOperations_spec_satisfied (nums: List Nat) (k: Nat) (h_precond : minOperations_precond (nums) (k)) :
    minOperations_postcond (nums) (k) (minOperations (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


