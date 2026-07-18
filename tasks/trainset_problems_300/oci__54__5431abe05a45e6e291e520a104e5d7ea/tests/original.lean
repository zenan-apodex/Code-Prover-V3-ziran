-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
abbrev DivideNumbersResult := Except String Float
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def DivideNumbers_precond (a : Float) (b : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def DivideNumbers (a : Float) (b : Float) (h_precond : DivideNumbers_precond a b) : DivideNumbersResult :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def divideByZeroMsg : String := "Error: Division by zero is not allowed."
-- !benchmark @end postcond_aux

@[reducible, simp]
def DivideNumbers_postcond (a : Float) (b : Float) (result : DivideNumbersResult)
    (h_precond : DivideNumbers_precond a b) : Prop :=
  -- !benchmark @start postcond
  (b = 0 → result = Except.error divideByZeroMsg) ∧
  (b ≠ 0 → result = Except.ok (a / b))
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem DivideNumbers_spec_satisfied (a : Float) (b : Float)
    (h_precond : DivideNumbers_precond a b) :
    DivideNumbers_postcond a b (DivideNumbers a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof