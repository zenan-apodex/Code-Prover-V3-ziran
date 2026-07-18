-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsEven_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsEven (num : Int) (h_precond : IsEven_precond num) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsEven_postcond (num : Int) (result : Bool) (h_precond : IsEven_precond num) : Prop :=
  -- !benchmark @start postcond
  (∃ k : Int, num = 2 * k) ↔ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsEven_spec_satisfied (num : Int) (h_precond : IsEven_precond num) :
    IsEven_postcond num (IsEven num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof