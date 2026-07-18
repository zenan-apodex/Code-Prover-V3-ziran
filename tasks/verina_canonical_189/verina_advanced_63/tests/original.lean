-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def removeDuplicates_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  -- nums are sorted in non-decreasing order
  List.Pairwise (· ≤ ·) nums
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def removeDuplicates (nums : List Int) (h_precond : removeDuplicates_precond (nums)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def removeDuplicates_postcond (nums : List Int) (result: Nat) (h_precond : removeDuplicates_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result - nums.eraseDups.length = 0 ∧
  nums.eraseDups.length ≤ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem removeDuplicates_spec_satisfied (nums: List Int) (h_precond : removeDuplicates_precond (nums)) :
    removeDuplicates_postcond (nums) (removeDuplicates (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
