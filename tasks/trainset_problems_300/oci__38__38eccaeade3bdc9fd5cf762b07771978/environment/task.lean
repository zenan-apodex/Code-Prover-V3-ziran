-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMaxAndMin_precond (values : List Int) : Prop :=
  -- !benchmark @start precond
  values ≠ []
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMaxAndMin (values : List Int) (h_precond : FindMaxAndMin_precond values) : Int × Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMaxAndMin_postcond (values : List Int) (result : Int × Int)
    (h_precond : FindMaxAndMin_precond values) : Prop :=
  -- !benchmark @start postcond
  result.1 ∈ values ∧
  result.2 ∈ values ∧
  (∀ x ∈ values, x ≤ result.1) ∧
  (∀ x ∈ values, result.2 ≤ x)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMaxAndMin_spec_satisfied (values : List Int)
    (h_precond : FindMaxAndMin_precond values) :
    FindMaxAndMin_postcond values (FindMaxAndMin values h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof