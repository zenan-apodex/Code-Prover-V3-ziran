-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPrime_precond (number : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ number ∧ number ≤ 1000000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPrime (number : Int) (h_precond : IsPrime_precond number) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPrime_postcond (number : Int) (result : Bool) (h_precond : IsPrime_precond number) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔
    2 ≤ number ∧
    ∀ d : Int, 1 < d → d < number → number % d ≠ 0
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPrime_spec_satisfied (number : Int) (h_precond : IsPrime_precond number) :
    IsPrime_postcond number (IsPrime number h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof