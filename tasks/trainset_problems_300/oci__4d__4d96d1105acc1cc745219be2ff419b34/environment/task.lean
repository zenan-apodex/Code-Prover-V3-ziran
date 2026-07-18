-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ReverseString_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ReverseString (input_string : String) (h_precond : ReverseString_precond input_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ReverseString_postcond (input_string : String) (result : String)
    (h_precond : ReverseString_precond input_string) : Prop :=
  -- !benchmark @start postcond
  result.toList.length = input_string.toList.length ∧
  ∀ i : Nat, i < input_string.toList.length →
    result.toList[i]! = input_string.toList[input_string.toList.length - 1 - i]!
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ReverseString_spec_satisfied (input_string : String)
    (h_precond : ReverseString_precond input_string) :
    ReverseString_postcond input_string (ReverseString input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof