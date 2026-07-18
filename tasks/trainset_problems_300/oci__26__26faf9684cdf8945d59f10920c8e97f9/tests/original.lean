-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindEvenNumbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindEvenNumbers (numbers : List Int) (h_precond : FindEvenNumbers_precond numbers) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindEvenNumbers_postcond (numbers : List Int) (result : List Int)
    (h_precond : FindEvenNumbers_precond numbers) : Prop :=
  -- !benchmark @start postcond
  result.Sublist numbers ∧
  (∀ x ∈ result, x % 2 = 0) ∧
  (∀ z : Int, result.count z = if z % 2 = 0 then numbers.count z else 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindEvenNumbers_spec_satisfied (numbers : List Int)
    (h_precond : FindEvenNumbers_precond numbers) :
    FindEvenNumbers_postcond numbers (FindEvenNumbers numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof