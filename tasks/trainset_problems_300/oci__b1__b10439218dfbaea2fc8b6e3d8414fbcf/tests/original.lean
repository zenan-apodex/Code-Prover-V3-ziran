-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CalculateArea_precond (length : Float) (width : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CalculateArea (length : Float) (width : Float)
    (h_precond : CalculateArea_precond length width) : Float :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CalculateArea_postcond (length : Float) (width : Float) (result : Float)
    (h_precond : CalculateArea_precond length width) : Prop :=
  -- !benchmark @start postcond
  result = length * width
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CalculateArea_spec_satisfied (length : Float) (width : Float)
    (h_precond : CalculateArea_precond length width) :
    CalculateArea_postcond length width (CalculateArea length width h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof