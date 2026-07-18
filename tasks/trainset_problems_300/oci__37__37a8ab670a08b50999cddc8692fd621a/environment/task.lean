-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SquareNumbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SquareNumbers (numbers : List Int) (h_precond : SquareNumbers_precond numbers) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SquareNumbers_postcond (numbers : List Int) (result : List Int)
    (h_precond : SquareNumbers_precond numbers) : Prop :=
  -- !benchmark @start postcond
  List.Forall₂ (fun x y => y = x * x) numbers result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SquareNumbers_spec_satisfied (numbers : List Int)
    (h_precond : SquareNumbers_precond numbers) :
    SquareNumbers_postcond numbers (SquareNumbers numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof