-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMissingNumber_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  arr.Nodup ∧ ∀ x ∈ arr, 1 ≤ x ∧ x ≤ (arr.length : Int) + 1
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMissingNumber (arr : List Int) (h_precond : FindMissingNumber_precond arr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMissingNumber_postcond (arr : List Int) (result : Int)
    (h_precond : FindMissingNumber_precond arr) : Prop :=
  -- !benchmark @start postcond
  1 ≤ result ∧
  result ≤ (arr.length : Int) + 1 ∧
  result ∉ arr ∧
  ∀ x : Int, 1 ≤ x ∧ x ≤ (arr.length : Int) + 1 ∧ x ≠ result → x ∈ arr
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMissingNumber_spec_satisfied (arr : List Int)
    (h_precond : FindMissingNumber_precond arr) :
    FindMissingNumber_postcond arr (FindMissingNumber arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof