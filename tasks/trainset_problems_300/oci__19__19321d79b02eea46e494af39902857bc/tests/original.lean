-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMinimumSum_precond (pens : List Int) (pencils : List Int) : Prop :=
  -- !benchmark @start precond
  pens ≠ [] ∧
  pencils ≠ [] ∧
  pens.length ≤ 1000 ∧
  pencils.length ≤ 1000 ∧
  (∀ p ∈ pens, 1 ≤ p ∧ p ≤ 10000) ∧
  (∀ q ∈ pencils, 1 ≤ q ∧ q ≤ 10000)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindMinimumSum (pens : List Int) (pencils : List Int)
    (h_precond : FindMinimumSum_precond pens pencils) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindMinimumSum_postcond (pens : List Int) (pencils : List Int) (result : Int)
    (h_precond : FindMinimumSum_precond pens pencils) : Prop :=
  -- !benchmark @start postcond
  (∃ pen, pen ∈ pens ∧ ∃ pencil, pencil ∈ pencils ∧ result = pen + pencil) ∧
  (∀ pen, pen ∈ pens → ∀ pencil, pencil ∈ pencils → result ≤ pen + pencil)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindMinimumSum_spec_satisfied (pens : List Int) (pencils : List Int)
    (h_precond : FindMinimumSum_precond pens pencils) :
    FindMinimumSum_postcond pens pencils (FindMinimumSum pens pencils h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof