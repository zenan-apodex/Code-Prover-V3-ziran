-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindLargestNumber_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindLargestNumber (arr : List Int) (h_precond : FindLargestNumber_precond arr) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindLargestNumber_postcond (arr : List Int) (result : Option Int)
    (h_precond : FindLargestNumber_precond arr) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => arr = []
  | some m => m ∈ arr ∧ ∀ x, x ∈ arr → x ≤ m
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindLargestNumber_spec_satisfied (arr : List Int)
    (h_precond : FindLargestNumber_precond arr) :
    FindLargestNumber_postcond arr (FindLargestNumber arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof