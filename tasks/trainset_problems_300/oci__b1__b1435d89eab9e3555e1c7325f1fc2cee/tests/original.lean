-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPrime_precond (num : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPrime (num : List Int) (h_precond : IsPrime_precond num) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IntIsPrime (z : Int) : Prop :=
  z > 1 ∧ Nat.Prime z.natAbs
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPrime_postcond (num : List Int) (result : Bool) (h_precond : IsPrime_precond num) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ ∃ x, x ∈ num ∧ IntIsPrime x
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPrime_spec_satisfied (num : List Int) (h_precond : IsPrime_precond num) :
    IsPrime_postcond num (IsPrime num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof