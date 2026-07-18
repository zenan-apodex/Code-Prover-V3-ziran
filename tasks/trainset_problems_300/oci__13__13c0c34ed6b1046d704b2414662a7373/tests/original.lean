-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SwapKeysValues_precond (input_dict : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) input_dict ∧
  List.Pairwise (fun a b => a.2 ≠ b.2) input_dict
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SwapKeysValues (input_dict : List (String × Int))
    (h_precond : SwapKeysValues_precond input_dict) : List (Int × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SwapKeysValues_postcond (input_dict : List (String × Int))
    (result : List (Int × String)) (h_precond : SwapKeysValues_precond input_dict) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ input_dict, (p.2, p.1) ∈ result) ∧
  (∀ q ∈ result, (q.2, q.1) ∈ input_dict) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SwapKeysValues_spec_satisfied (input_dict : List (String × Int))
    (h_precond : SwapKeysValues_precond input_dict) :
    SwapKeysValues_postcond input_dict (SwapKeysValues input_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof