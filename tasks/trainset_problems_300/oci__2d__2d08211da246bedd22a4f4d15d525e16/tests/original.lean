-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMaxMinDifference_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums.length ≤ 100000 ∧
  ∀ num ∈ nums, (-1000000000 : Int) ≤ num ∧ num ≤ (1000000000 : Int)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindMaxMinDifference (nums : List Int) (h_precond : FindMaxMinDifference_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsListMinimum (nums : List Int) (m : Int) : Prop :=
  m ∈ nums ∧ ∀ x ∈ nums, m ≤ x

def IsListMaximum (nums : List Int) (m : Int) : Prop :=
  m ∈ nums ∧ ∀ x ∈ nums, x ≤ m
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindMaxMinDifference_postcond (nums : List Int) (result : Int)
    (h_precond : FindMaxMinDifference_precond nums) : Prop :=
  -- !benchmark @start postcond
  (nums = [] → result = 0) ∧
  (nums ≠ [] →
    ∃ mn mx, IsListMinimum nums mn ∧ IsListMaximum nums mx ∧ result = mx - mn)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindMaxMinDifference_spec_satisfied (nums : List Int)
    (h_precond : FindMaxMinDifference_precond nums) :
    FindMaxMinDifference_postcond nums (FindMaxMinDifference nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof