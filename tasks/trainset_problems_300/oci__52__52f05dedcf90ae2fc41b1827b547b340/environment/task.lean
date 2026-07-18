-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MinBoundingRectangle_precond (points : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  points ≠ []
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MinBoundingRectangle (points : List (Int × Int))
    (h_precond : MinBoundingRectangle_precond points) : Int × Int × Int × Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MinBoundingRectangle_postcond (points : List (Int × Int))
    (result : Int × Int × Int × Int)
    (h_precond : MinBoundingRectangle_precond points) : Prop :=
  -- !benchmark @start postcond
  let (minx, miny, maxx, maxy) := result
  minx ≤ maxx ∧
  miny ≤ maxy ∧
  (∀ p ∈ points, minx ≤ p.1 ∧ p.1 ≤ maxx ∧ miny ≤ p.2 ∧ p.2 ≤ maxy) ∧
  (∃ p ∈ points, p.1 = minx) ∧
  (∃ p ∈ points, p.1 = maxx) ∧
  (∃ p ∈ points, p.2 = miny) ∧
  (∃ p ∈ points, p.2 = maxy)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MinBoundingRectangle_spec_satisfied (points : List (Int × Int))
    (h_precond : MinBoundingRectangle_precond points) :
    MinBoundingRectangle_postcond points (MinBoundingRectangle points h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof