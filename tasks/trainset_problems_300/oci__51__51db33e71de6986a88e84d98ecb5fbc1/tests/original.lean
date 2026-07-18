-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SumOfSquares_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SumOfSquares (n : Int) (h_precond : SumOfSquares_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SumOfSquares_postcond (n : Int) (result : Int)
    (h_precond : SumOfSquares_precond n) : Prop :=
  -- !benchmark @start postcond
  (n ≤ 0 → result = 0) ∧
  (0 < n → 6 * result = n * (n + 1) * (2 * n + 1))
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SumOfSquares_spec_satisfied (n : Int)
    (h_precond : SumOfSquares_precond n) :
    SumOfSquares_postcond n (SumOfSquares n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof