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
  True
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
  let cs := s.toList
  let rs := result.toList
  rs.length = cs.length ∧
  ∀ i : Nat, i < cs.length → rs[i]! = cs[cs.length - 1 - i]!
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ReverseString_spec_satisfied (s : String) (h_precond : ReverseString_precond s) :
    ReverseString_postcond s (ReverseString s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof