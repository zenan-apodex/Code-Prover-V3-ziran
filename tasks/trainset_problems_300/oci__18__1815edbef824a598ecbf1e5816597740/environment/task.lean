-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateCombinations_precond (item_list : List String) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≠ b) item_list ∧ item_list.length ≤ 100
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def GenerateCombinations (item_list : List String)
    (h_precond : GenerateCombinations_precond item_list) : List (String × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def GenerateCombinations_postcond (item_list : List String) (result : List (String × String))
    (h_precond : GenerateCombinations_precond item_list) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, ∃ i j : Nat,
      i < j ∧ j < item_list.length ∧ p = (item_list[i]!, item_list[j]!)) ∧
  (∀ i j : Nat, i < j → j < item_list.length →
      (item_list[i]!, item_list[j]!) ∈ result) ∧
  List.Pairwise (fun a b => a ≠ b) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem GenerateCombinations_spec_satisfied (item_list : List String)
    (h_precond : GenerateCombinations_precond item_list) :
    GenerateCombinations_postcond item_list (GenerateCombinations item_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof