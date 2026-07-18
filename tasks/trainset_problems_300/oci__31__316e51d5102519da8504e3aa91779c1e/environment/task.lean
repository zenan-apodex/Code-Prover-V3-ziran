-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PellNumber_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 50
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def PellNumber (n : Int) (h_precond : PellNumber_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive PellRel : Nat → Int → Prop
| zero : PellRel 0 0
| one : PellRel 1 1
| step (k : Nat) (pk pk1 : Int) :
    PellRel k pk →
    PellRel (k + 1) pk1 →
    PellRel (k + 2) (2 * pk1 + pk)
-- !benchmark @end postcond_aux


@[reducible, simp]
def PellNumber_postcond (n : Int) (result : Int) (h_precond : PellNumber_precond n) : Prop :=
  -- !benchmark @start postcond
  PellRel (Int.toNat n) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem PellNumber_spec_satisfied (n : Int) (h_precond : PellNumber_precond n) :
    PellNumber_postcond n (PellNumber n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof