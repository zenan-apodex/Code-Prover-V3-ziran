-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def CanPartition_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ x ∈ nums, x ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def CanPartition (nums : List Int) (h_precond : CanPartition_precond nums) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A mask is a list of booleans of the same length as `nums`.
    The "selected" subset consists of elements where the mask is true. -/
def subsetSum (nums : List Int) (mask : List Bool) : Int :=
  (nums.zip mask).foldl (fun acc (x, b) => if b then acc + x else acc) 0
-- !benchmark @end postcond_aux


@[reducible, simp]
def CanPartition_postcond (nums : List Int) (result : Bool) (h_precond : CanPartition_precond nums) : Prop :=
  -- !benchmark @start postcond
  let totalSum := nums.foldl (· + ·) 0
  result = true ↔
    (∃ mask : List Bool,
      mask.length = nums.length ∧
      subsetSum nums mask * 2 = totalSum)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem CanPartition_spec_satisfied (nums : List Int) (h_precond : CanPartition_precond nums) :
    CanPartition_postcond nums (CanPartition nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof