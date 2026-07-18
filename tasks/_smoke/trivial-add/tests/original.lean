-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def myAdd_precond (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def myAdd (a : Nat) (b : Nat) (h_precond : myAdd_precond a b) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def myAdd_postcond (a : Nat) (b : Nat) (result : Nat) (h_precond : myAdd_precond a b) : Prop :=
  -- !benchmark @start postcond
  result = a + b
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem myAdd_spec_satisfied (a : Nat) (b : Nat) (h_precond : myAdd_precond a b) :
    myAdd_postcond a b (myAdd a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
