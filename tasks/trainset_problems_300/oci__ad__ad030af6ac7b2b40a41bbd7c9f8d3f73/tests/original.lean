-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindDuplicates_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindDuplicates (lst : List Int) (h_precond : FindDuplicates_precond lst) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def occursAtLeastTwice (x : Int) (lst : List Int) : Prop :=
  2 ≤ (lst.filter (· = x)).length
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindDuplicates_postcond (lst : List Int) (result : List Int)
    (h_precond : FindDuplicates_precond lst) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a ≠ b) result ∧
  (∀ x : Int, x ∈ result ↔ occursAtLeastTwice x lst)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindDuplicates_spec_satisfied (lst : List Int)
    (h_precond : FindDuplicates_precond lst) :
    FindDuplicates_postcond lst (FindDuplicates lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof