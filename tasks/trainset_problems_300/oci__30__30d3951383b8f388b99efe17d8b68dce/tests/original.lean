-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MatrixMult_precond (A : Int) : Prop :=
  -- !benchmark @start precond
  A ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MatrixMult (A : Int) (h_precond : MatrixMult_precond A) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsFibSequence (f : Nat → Int) : Prop :=
  f 0 = 0 ∧
  f 1 = 1 ∧
  ∀ k : Nat, f (k + 2) = f (k + 1) + f k
-- !benchmark @end postcond_aux


@[reducible, simp]
def MatrixMult_postcond (A : Int) (result : Int) (h_precond : MatrixMult_precond A) : Prop :=
  -- !benchmark @start postcond
  ∃ f : Nat → Int, IsFibSequence f ∧ result = f (Int.toNat A)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MatrixMult_spec_satisfied (A : Int) (h_precond : MatrixMult_precond A) :
    MatrixMult_postcond A (MatrixMult A h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof