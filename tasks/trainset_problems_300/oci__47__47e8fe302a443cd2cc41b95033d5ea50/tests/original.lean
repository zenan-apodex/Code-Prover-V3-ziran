-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def AddNumbers_precond (a : Int) (b : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def AddNumbers (a : Int) (b : Int) (h_precond : AddNumbers_precond a b) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def AddNumbers_postcond (a : Int) (b : Int) (result : Int)
    (h_precond : AddNumbers_precond a b) : Prop :=
  -- !benchmark @start postcond
  result = a + b
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem AddNumbers_spec_satisfied (a : Int) (b : Int)
    (h_precond : AddNumbers_precond a b) :
    AddNumbers_postcond a b (AddNumbers a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof