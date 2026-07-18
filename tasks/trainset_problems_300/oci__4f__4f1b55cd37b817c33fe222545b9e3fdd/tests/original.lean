-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FirstMissingPositive_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FirstMissingPositive (nums : List Int) (h_precond : FirstMissingPositive_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FirstMissingPositive_postcond (nums : List Int) (result : Int)
    (h_precond : FirstMissingPositive_precond nums) : Prop :=
  -- !benchmark @start postcond
  0 < result ∧
  result ∉ nums ∧
  ∀ z : Int, 0 < z → z < result → z ∈ nums
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FirstMissingPositive_spec_satisfied (nums : List Int)
    (h_precond : FirstMissingPositive_precond nums) :
    FirstMissingPositive_postcond nums (FirstMissingPositive nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof