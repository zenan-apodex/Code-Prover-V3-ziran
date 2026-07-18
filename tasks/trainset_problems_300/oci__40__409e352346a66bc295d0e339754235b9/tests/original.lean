-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMaximum_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ numbers.length ∧
  numbers.length ≤ 1000 ∧
  ∀ x ∈ numbers, (-1000 : Int) ≤ x ∧ x ≤ 1000
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMaximum (numbers : List Int) (h_precond : FindMaximum_precond numbers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMaximum_postcond (numbers : List Int) (result : Int)
    (h_precond : FindMaximum_precond numbers) : Prop :=
  -- !benchmark @start postcond
  result ∈ numbers ∧ ∀ x ∈ numbers, x ≤ result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMaximum_spec_satisfied (numbers : List Int)
    (h_precond : FindMaximum_precond numbers) :
    FindMaximum_postcond numbers (FindMaximum numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof