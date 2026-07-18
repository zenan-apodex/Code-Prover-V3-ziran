-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SecondLargestUnique_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SecondLargestUnique (numbers : List Int) (h_precond : SecondLargestUnique_precond numbers) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def IsSecondLargestUnique (numbers : List Int) (x : Int) : Prop :=
  x ∈ numbers ∧
  ∃ y : Int,
    y ∈ numbers ∧
    x < y ∧
    (∀ z : Int, z ∈ numbers → z ≤ y) ∧
    (∀ z : Int, z ∈ numbers → z < y → z ≤ x)

def HasAtLeastTwoDistinct (numbers : List Int) : Prop :=
  ∃ x y : Int, x ∈ numbers ∧ y ∈ numbers ∧ x ≠ y
-- !benchmark @end postcond_aux

@[reducible, simp]
def SecondLargestUnique_postcond (numbers : List Int) (result : Option Int)
    (h_precond : SecondLargestUnique_precond numbers) : Prop :=
  -- !benchmark @start postcond
  match result with
  | some x =>
      IsSecondLargestUnique numbers x
  | none =>
      ¬ HasAtLeastTwoDistinct numbers
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SecondLargestUnique_spec_satisfied (numbers : List Int)
    (h_precond : SecondLargestUnique_precond numbers) :
    SecondLargestUnique_postcond numbers (SecondLargestUnique numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof