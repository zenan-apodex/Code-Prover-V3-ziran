-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SquareIfPositive_precond (x : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SquareIfPositive (x : Float) (h_precond : SquareIfPositive_precond x) : Float :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SquareIfPositive_postcond (x : Float) (result : Float)
    (h_precond : SquareIfPositive_precond x) : Prop :=
  -- !benchmark @start postcond
  (0 < x → result = x * x) ∧
  (¬ (0 < x) → result = 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SquareIfPositive_spec_satisfied (x : Float)
    (h_precond : SquareIfPositive_precond x) :
    SquareIfPositive_postcond x (SquareIfPositive x h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof