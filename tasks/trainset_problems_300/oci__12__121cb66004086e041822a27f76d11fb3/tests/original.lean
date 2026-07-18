-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPerfectSquare_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPerfectSquare (n : Int) (h_precond : IsPerfectSquare_precond n) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPerfectSquare_postcond (n : Int) (result : Bool) (h_precond : IsPerfectSquare_precond n) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ ∃ z : Int, z * z = n
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPerfectSquare_spec_satisfied (n : Int) (h_precond : IsPerfectSquare_precond n) :
    IsPerfectSquare_postcond n (IsPerfectSquare n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof