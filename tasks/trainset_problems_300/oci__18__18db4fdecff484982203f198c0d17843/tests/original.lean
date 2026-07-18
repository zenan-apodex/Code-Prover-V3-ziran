-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CalculateAreas_precond (rectangles : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CalculateAreas (rectangles : List (Int × Int)) (h_precond : CalculateAreas_precond rectangles) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CalculateAreas_postcond (rectangles : List (Int × Int)) (result : List Int)
    (h_precond : CalculateAreas_precond rectangles) : Prop :=
  -- !benchmark @start postcond
  result.length = rectangles.length ∧
  ∀ i : Nat, i < rectangles.length →
    result[i]! = (rectangles[i]!).1 * (rectangles[i]!).2
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CalculateAreas_spec_satisfied (rectangles : List (Int × Int))
    (h_precond : CalculateAreas_precond rectangles) :
    CalculateAreas_postcond rectangles (CalculateAreas rectangles h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof