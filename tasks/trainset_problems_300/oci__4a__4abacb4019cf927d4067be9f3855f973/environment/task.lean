-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMin_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums ≠ []
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMin (nums : List Int) (h_precond : FindMin_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMin_postcond (nums : List Int) (result : Int)
    (h_precond : FindMin_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ∈ nums ∧ ∀ x, x ∈ nums → result ≤ x
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMin_spec_satisfied (nums : List Int)
    (h_precond : FindMin_precond nums) :
    FindMin_postcond nums (FindMin nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof