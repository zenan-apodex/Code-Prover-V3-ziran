-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SecondHighestUnique_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SecondHighestUnique (numbers : List Int)
    (h_precond : SecondHighestUnique_precond numbers) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsSecondHighestUniqueValue (numbers : List Int) (x : Int) : Prop :=
  x ∈ numbers ∧
  ∃ m : Int,
    m ∈ numbers ∧
    x < m ∧
    (∀ z : Int, z ∈ numbers → z ≤ m) ∧
    (∀ z : Int, z ∈ numbers → z < m → z ≤ x)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SecondHighestUnique_postcond (numbers : List Int) (result : Option Int)
    (h_precond : SecondHighestUnique_precond numbers) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ¬ ∃ x : Int, IsSecondHighestUniqueValue numbers x
  | some x => IsSecondHighestUniqueValue numbers x
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SecondHighestUnique_spec_satisfied (numbers : List Int)
    (h_precond : SecondHighestUnique_precond numbers) :
    SecondHighestUnique_postcond numbers (SecondHighestUnique numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof