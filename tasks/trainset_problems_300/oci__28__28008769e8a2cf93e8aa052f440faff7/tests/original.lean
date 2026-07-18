-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPrime_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPrime (n : Int) (h_precond : IsPrime_precond n) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPrimeInt (n : Int) : Prop :=
  ∃ m : Nat, n = (m : Int) ∧ Nat.Prime m
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPrime_postcond (n : Int) (result : Bool) (h_precond : IsPrime_precond n) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ IsPrimeInt n
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPrime_spec_satisfied (n : Int) (h_precond : IsPrime_precond n) :
    IsPrime_postcond n (IsPrime n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof