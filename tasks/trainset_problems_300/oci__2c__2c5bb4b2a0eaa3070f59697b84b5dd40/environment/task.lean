-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindIntersection_precond (list1 : List Int) (list2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindIntersection (list1 : List Int) (list2 : List Int)
    (h_precond : FindIntersection_precond list1 list2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindIntersection_postcond (list1 : List Int) (list2 : List Int)
    (result : List Int) (h_precond : FindIntersection_precond list1 list2) : Prop :=
  -- !benchmark @start postcond
  (∀ x, x ∈ result ↔ x ∈ list1 ∧ x ∈ list2) ∧
  List.Pairwise (fun a b => a ≠ b) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindIntersection_spec_satisfied (list1 : List Int) (list2 : List Int)
    (h_precond : FindIntersection_precond list1 list2) :
    FindIntersection_postcond list1 list2 (FindIntersection list1 list2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof