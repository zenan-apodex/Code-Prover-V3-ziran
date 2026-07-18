-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def smallestMissing_precond (l : List Nat) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (· < ·) l
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def smallestMissing (l : List Nat) (h_precond : smallestMissing_precond (l)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def smallestMissing_postcond (l : List Nat) (result: Nat) (h_precond : smallestMissing_precond (l)) : Prop :=
  -- !benchmark @start postcond
  result ∉ l ∧ ∀ candidate : Nat, candidate < result → candidate ∈ l
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem smallestMissing_spec_satisfied (l: List Nat) (h_precond : smallestMissing_precond (l)) :
    smallestMissing_postcond (l) (smallestMissing (l) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


