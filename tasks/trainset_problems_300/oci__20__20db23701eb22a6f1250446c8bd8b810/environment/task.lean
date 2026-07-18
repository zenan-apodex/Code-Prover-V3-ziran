-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindLargestNumber_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  numbers ≠ []
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindLargestNumber (numbers : List Int) (h_precond : FindLargestNumber_precond numbers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindLargestNumber_postcond (numbers : List Int) (result : Int)
    (h_precond : FindLargestNumber_precond numbers) : Prop :=
  -- !benchmark @start postcond
  result ∈ numbers ∧ ∀ x, x ∈ numbers → x ≤ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindLargestNumber_spec_satisfied (numbers : List Int)
    (h_precond : FindLargestNumber_precond numbers) :
    FindLargestNumber_postcond numbers (FindLargestNumber numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof