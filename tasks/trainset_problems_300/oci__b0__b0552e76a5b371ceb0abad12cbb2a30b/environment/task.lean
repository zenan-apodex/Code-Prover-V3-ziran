-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindIntersection_precond (set1 : List Int) (set2 : List Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≠ b) set1 ∧
  List.Pairwise (fun a b => a ≠ b) set2
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindIntersection (set1 : List Int) (set2 : List Int)
    (h_precond : FindIntersection_precond set1 set2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindIntersection_postcond (set1 : List Int) (set2 : List Int) (result : List Int)
    (h_precond : FindIntersection_precond set1 set2) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a ≠ b) result ∧
  (∀ x : Int, x ∈ result ↔ x ∈ set1 ∧ x ∈ set2)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindIntersection_spec_satisfied (set1 : List Int) (set2 : List Int)
    (h_precond : FindIntersection_precond set1 set2) :
    FindIntersection_postcond set1 set2 (FindIntersection set1 set2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof