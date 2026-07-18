-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def F_precond (x : Int) : Prop :=
  -- !benchmark @start precond
  -1000000000 ≤ x ∧ x ≤ 1000000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def F (x : Int) (h_precond : F_precond x) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def F_postcond (x : Int) (result : Int) (h_precond : F_precond x) : Prop :=
  -- !benchmark @start postcond
  (x < 0 → result = 0) ∧
  (0 ≤ x → result = 2 * x)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem F_spec_satisfied (x : Int) (h_precond : F_precond x) :
    F_postcond x (F x h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof