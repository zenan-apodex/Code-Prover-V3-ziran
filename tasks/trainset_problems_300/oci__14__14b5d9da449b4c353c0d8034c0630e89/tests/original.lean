-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortPointsByOriginDistance_precond (points : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortPointsByOriginDistance (points : List (Int × Int))
    (h_precond : SortPointsByOriginDistance_precond points) : List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def pointDistSq (p : Int × Int) : Int :=
  p.1 * p.1 + p.2 * p.2
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortPointsByOriginDistance_postcond (points : List (Int × Int))
    (result : List (Int × Int))
    (h_precond : SortPointsByOriginDistance_precond points) : Prop :=
  -- !benchmark @start postcond
  result.Perm points ∧
  List.Pairwise (fun p q => pointDistSq p ≤ pointDistSq q) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortPointsByOriginDistance_spec_satisfied (points : List (Int × Int))
    (h_precond : SortPointsByOriginDistance_precond points) :
    SortPointsByOriginDistance_postcond points
      (SortPointsByOriginDistance points h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof