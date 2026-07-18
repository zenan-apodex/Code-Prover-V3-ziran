-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxDifference_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MaxDifference (nums : List Int) (h_precond : MaxDifference_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MaxDifference_postcond (nums : List Int) (result : Int)
    (h_precond : MaxDifference_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  (∀ i j, ∀ hi : i < nums.length, ∀ hj : j < nums.length,
      i < j → nums.get ⟨j, hj⟩ - nums.get ⟨i, hi⟩ ≤ result) ∧
  (result = 0 ∨
    ∃ i j, ∃ hi : i < nums.length, ∃ hj : j < nums.length,
      i < j ∧ result = nums.get ⟨j, hj⟩ - nums.get ⟨i, hi⟩)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MaxDifference_spec_satisfied (nums : List Int)
    (h_precond : MaxDifference_precond nums) :
    MaxDifference_postcond nums (MaxDifference nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof