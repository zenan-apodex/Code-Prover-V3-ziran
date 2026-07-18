-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def SquareRoot_precond (N : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def SquareRoot (N : Nat) (h_precond : SquareRoot_precond (N)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def SquareRoot_postcond (N : Nat) (result: Nat) (h_precond : SquareRoot_precond (N)) :=
  -- !benchmark @start postcond
  result * result ≤ N ∧ N < (result + 1) * (result + 1)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem SquareRoot_spec_satisfied (N: Nat) (h_precond : SquareRoot_precond (N)) :
    SquareRoot_postcond (N) (SquareRoot (N) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
