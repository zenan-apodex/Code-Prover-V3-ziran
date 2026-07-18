-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMax_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindMax (numbers : List Int) (h_precond : FindMax_precond numbers) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindMax_postcond (numbers : List Int) (result : Option Int)
    (h_precond : FindMax_precond numbers) : Prop :=
  -- !benchmark @start postcond
  (numbers = [] → result = none) ∧
  (∀ x, result = some x →
    x ∈ numbers ∧ ∀ y, y ∈ numbers → y ≤ x) ∧
  (numbers ≠ [] → ∃ x, result = some x)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindMax_spec_satisfied (numbers : List Int)
    (h_precond : FindMax_precond numbers) :
    FindMax_postcond numbers (FindMax numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof