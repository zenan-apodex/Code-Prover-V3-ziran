-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMaxRecursive_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  lst ≠ []
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMaxRecursive (lst : List Int) (h_precond : FindMaxRecursive_precond lst) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMaxRecursive_postcond (lst : List Int) (result : Int)
    (h_precond : FindMaxRecursive_precond lst) : Prop :=
  -- !benchmark @start postcond
  result ∈ lst ∧ ∀ x, x ∈ lst → x ≤ result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMaxRecursive_spec_satisfied (lst : List Int)
    (h_precond : FindMaxRecursive_precond lst) :
    FindMaxRecursive_postcond lst (FindMaxRecursive lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof