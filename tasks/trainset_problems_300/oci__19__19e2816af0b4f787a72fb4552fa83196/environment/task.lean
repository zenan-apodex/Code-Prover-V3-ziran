-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsEven_precond (x : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsEven (x : Int) (h_precond : IsEven_precond x) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsEven_postcond (x : Int) (result : Bool) (h_precond : IsEven_precond x) : Prop :=
  -- !benchmark @start postcond
  (∃ k : Int, x = 2 * k) ↔ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsEven_spec_satisfied (x : Int) (h_precond : IsEven_precond x) :
    IsEven_postcond x (IsEven x h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof