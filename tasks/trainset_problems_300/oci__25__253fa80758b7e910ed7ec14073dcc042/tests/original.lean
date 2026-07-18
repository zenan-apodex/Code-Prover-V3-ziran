-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaximumProductOfThree_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums.length ≥ 3
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaximumProductOfThree (nums : List Int) (h_precond : MaximumProductOfThree_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def ValidTripleIndices (nums : List Int) (i j k : Nat) : Prop :=
  i < nums.length ∧
  j < nums.length ∧
  k < nums.length ∧
  i ≠ j ∧ i ≠ k ∧ j ≠ k

def TripleProduct (nums : List Int) (i j k : Nat) : Int :=
  nums[i]! * nums[j]! * nums[k]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaximumProductOfThree_postcond (nums : List Int) (result : Int)
    (h_precond : MaximumProductOfThree_precond nums) : Prop :=
  -- !benchmark @start postcond
  (∃ i j k : Nat, ValidTripleIndices nums i j k ∧ result = TripleProduct nums i j k) ∧
  (∀ i j k : Nat, ValidTripleIndices nums i j k → TripleProduct nums i j k ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaximumProductOfThree_spec_satisfied (nums : List Int)
    (h_precond : MaximumProductOfThree_precond nums) :
    MaximumProductOfThree_postcond nums (MaximumProductOfThree nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof