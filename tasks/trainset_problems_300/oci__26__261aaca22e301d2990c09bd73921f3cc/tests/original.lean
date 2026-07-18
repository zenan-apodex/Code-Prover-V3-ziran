-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindSecondLargest_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ numbers.length
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindSecondLargest (numbers : List Int) (h_precond : FindSecondLargest_precond numbers) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindSecondLargest_postcond (numbers : List Int) (result : Option Int)
    (h_precond : FindSecondLargest_precond numbers) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none =>
      ¬ ∃ a, a ∈ numbers ∧ ∃ b, b ∈ numbers ∧ a ≠ b
  | some x =>
      x ∈ numbers ∧
      ∃ m, m ∈ numbers ∧ x < m ∧
        (∀ z, z ∈ numbers → z ≤ m) ∧
        (∀ z, z ∈ numbers → z < m → z ≤ x)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindSecondLargest_spec_satisfied (numbers : List Int)
    (h_precond : FindSecondLargest_precond numbers) :
    FindSecondLargest_postcond numbers (FindSecondLargest numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof