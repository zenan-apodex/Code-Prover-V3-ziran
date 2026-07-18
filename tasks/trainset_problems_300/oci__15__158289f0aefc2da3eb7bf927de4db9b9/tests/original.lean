-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountWaysToReachTarget_precond (target : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ target ∧ target ≤ 50
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountWaysToReachTarget (target : Int) (h_precond : CountWaysToReachTarget_precond target) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def ValidWaysSequenceUpTo (t : Nat) (ways : Nat → Int) : Prop :=
  ways 0 = 1 ∧
  ways 1 = 1 ∧
  ∀ n : Nat, 2 ≤ n → n ≤ t → ways n = ways (n - 1) + ways (n - 2)
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountWaysToReachTarget_postcond (target : Int) (result : Int)
    (h_precond : CountWaysToReachTarget_precond target) : Prop :=
  -- !benchmark @start postcond
  ∃ ways : Nat → Int,
    ValidWaysSequenceUpTo (Int.toNat target) ways ∧
    result = ways (Int.toNat target)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountWaysToReachTarget_spec_satisfied (target : Int)
    (h_precond : CountWaysToReachTarget_precond target) :
    CountWaysToReachTarget_postcond target (CountWaysToReachTarget target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof