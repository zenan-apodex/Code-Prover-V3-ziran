-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SecondSmallest_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SecondSmallest (numbers : List Int) (h_precond : SecondSmallest_precond numbers) : Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsSecondSmallestUnique (numbers : List Int) (r : Int) : Prop :=
  r ∈ numbers ∧
  ∃ m : Int, m ∈ numbers ∧ m < r ∧
    (∀ x : Int, x ∈ numbers → x = m ∨ r ≤ x)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SecondSmallest_postcond (numbers : List Int) (result : Option Int)
    (h_precond : SecondSmallest_precond numbers) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ∀ r : Int, ¬ IsSecondSmallestUnique numbers r
  | some r => IsSecondSmallestUnique numbers r
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SecondSmallest_spec_satisfied (numbers : List Int)
    (h_precond : SecondSmallest_precond numbers) :
    SecondSmallest_postcond numbers (SecondSmallest numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof