-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindSecondLargest_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindSecondLargest (nums : List Int) (h_precond : FindSecondLargest_precond nums) :
    Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def FindSecondLargest_HasAtMostOneDistinct (nums : List Int) : Prop :=
  ∀ a ∈ nums, ∀ b ∈ nums, a = b

def FindSecondLargest_IsSecondLargestOf (nums : List Int) (x : Int) : Prop :=
  x ∈ nums ∧
    ∃ m ∈ nums,
      x < m ∧
      (∀ z ∈ nums, z ≤ m) ∧
      (∀ z ∈ nums, z < m → z ≤ x)
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindSecondLargest_postcond (nums : List Int) (result : Option Int)
    (h_precond : FindSecondLargest_precond nums) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => FindSecondLargest_HasAtMostOneDistinct nums
  | some x => FindSecondLargest_IsSecondLargestOf nums x
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindSecondLargest_spec_satisfied (nums : List Int)
    (h_precond : FindSecondLargest_precond nums) :
    FindSecondLargest_postcond nums (FindSecondLargest nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof