-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def arraySum_precond (a : Array Int) (b : Array Int) : Prop :=
  -- !benchmark @start precond
  a.size = b.size
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def arraySum (a : Array Int) (b : Array Int) (h_precond : arraySum_precond (a) (b)) : Array Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def arraySum_postcond (a : Array Int) (b : Array Int) (result: Array Int) (h_precond : arraySum_precond (a) (b)) :=
  -- !benchmark @start postcond
  (result.size = a.size) ∧ (∀ i : Nat, i < a.size → a[i]! + b[i]! = result[i]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem arraySum_spec_satisfied (a: Array Int) (b: Array Int) (h_precond : arraySum_precond (a) (b)) :
    arraySum_postcond (a) (b) (arraySum (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
