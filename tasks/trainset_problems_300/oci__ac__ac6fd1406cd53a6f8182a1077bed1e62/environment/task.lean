-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Divide_precond (a : Float) (b : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def Divide (a : Float) (b : Float) (h_precond : Divide_precond a b) : Except String Float :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def Divide_divisionByZeroMsg : String :=
  "Error: Division by zero is not allowed."
-- !benchmark @end postcond_aux


@[reducible, simp]
def Divide_postcond (a : Float) (b : Float) (result : Except String Float)
    (h_precond : Divide_precond a b) : Prop :=
  -- !benchmark @start postcond
  match result with
  | Except.error msg => b = 0 ∧ msg = Divide_divisionByZeroMsg
  | Except.ok q => b ≠ 0 ∧ q = a / b
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Divide_spec_satisfied (a : Float) (b : Float) (h_precond : Divide_precond a b) :
    Divide_postcond a b (Divide a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof