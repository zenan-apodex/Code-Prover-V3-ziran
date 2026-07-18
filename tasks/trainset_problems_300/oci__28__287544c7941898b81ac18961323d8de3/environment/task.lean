-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MultiplyAndShift_precond (A : Int) (B : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ A ∧ 0 ≤ B ∧ A ≤ 1000 ∧ B ≤ 1000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MultiplyAndShift (A : Int) (B : Int) (h_precond : MultiplyAndShift_precond A B) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def MultiplyAndShift_postcond (A : Int) (B : Int) (result : Int)
    (h_precond : MultiplyAndShift_precond A B) : Prop :=
  -- !benchmark @start postcond
  result = A * B
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MultiplyAndShift_spec_satisfied (A : Int) (B : Int)
    (h_precond : MultiplyAndShift_precond A B) :
    MultiplyAndShift_postcond A B (MultiplyAndShift A B h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof