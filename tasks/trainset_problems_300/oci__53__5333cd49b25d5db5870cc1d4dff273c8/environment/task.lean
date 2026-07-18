-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMax_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMax (nums : List Int) (h_precond : FindMax_precond nums) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMax_postcond (nums : List Int) (result : Option Int)
    (h_precond : FindMax_precond nums) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => nums = []
  | some m => m ∈ nums ∧ ∀ x, x ∈ nums → x ≤ m
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMax_spec_satisfied (nums : List Int)
    (h_precond : FindMax_precond nums) :
    FindMax_postcond nums (FindMax nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof