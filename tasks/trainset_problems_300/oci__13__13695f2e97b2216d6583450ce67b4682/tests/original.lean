-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortAndDeduplicate_precond (strings_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortAndDeduplicate (strings_list : List String)
    (h_precond : SortAndDeduplicate_precond strings_list) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortAndDeduplicate_postcond (strings_list : List String) (result : List String)
    (h_precond : SortAndDeduplicate_precond strings_list) : Prop :=
  -- !benchmark @start postcond
  (∀ s : String, s ∈ result ↔ s ∈ strings_list) ∧
  List.Pairwise (fun a b => a < b) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortAndDeduplicate_spec_satisfied (strings_list : List String)
    (h_precond : SortAndDeduplicate_precond strings_list) :
    SortAndDeduplicate_postcond strings_list
      (SortAndDeduplicate strings_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof