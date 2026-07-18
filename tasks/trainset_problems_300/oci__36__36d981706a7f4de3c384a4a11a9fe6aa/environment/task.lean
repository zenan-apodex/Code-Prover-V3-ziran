-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ReverseString_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≤ 1000
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ReverseString (s : String) (h_precond : ReverseString_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ReverseString_postcond (s : String) (result : String)
    (h_precond : ReverseString_precond s) : Prop :=
  -- !benchmark @start postcond
  result.toList = s.toList.reverse
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ReverseString_spec_satisfied (s : String)
    (h_precond : ReverseString_precond s) :
    ReverseString_postcond s (ReverseString s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof