-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def AllCombinations_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def AllCombinations (s : String) (h_precond : AllCombinations_precond s) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsCombinationString (s t : String) : Prop :=
  List.Sublist t.toList s.toList
-- !benchmark @end postcond_aux


@[reducible, simp]
def AllCombinations_postcond (s : String) (result : List String)
    (h_precond : AllCombinations_precond s) : Prop :=
  -- !benchmark @start postcond
  (∀ t : String, t ∈ result ↔ IsCombinationString s t) ∧
  List.Pairwise (fun a b => a ≠ b) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem AllCombinations_spec_satisfied (s : String) (h_precond : AllCombinations_precond s) :
    AllCombinations_postcond s (AllCombinations s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof