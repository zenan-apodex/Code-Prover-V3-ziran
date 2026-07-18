-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def SmallestM_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 1000000
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def SmallestM (n : Int) (h_precond : SmallestM_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPerfectSquare (k : Int) : Prop :=
  ∃ r : Int, r ≥ 0 ∧ r * r = k
-- !benchmark @end postcond_aux


@[reducible, simp]
def SmallestM_postcond (n : Int) (result : Int) (h_precond : SmallestM_precond n) : Prop :=
  -- !benchmark @start postcond
  result ≥ 1 ∧
  isPerfectSquare (n * result) ∧
  (∀ m' : Int, 1 ≤ m' → m' < result → ¬ isPerfectSquare (n * m'))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem SmallestM_spec_satisfied (n : Int) (h_precond : SmallestM_precond n) :
    SmallestM_postcond n (SmallestM n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof