-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortDictByValuesDesc_precond (input_dict : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) input_dict
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortDictByValuesDesc (input_dict : List (String × Int))
    (h_precond : SortDictByValuesDesc_precond input_dict) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortDictByValuesDesc_postcond (input_dict : List (String × Int))
    (result : List (String × Int))
    (h_precond : SortDictByValuesDesc_precond input_dict) : Prop :=
  -- !benchmark @start postcond
  result.Perm input_dict ∧
  List.Pairwise (fun a b => a.2 ≥ b.2) result ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortDictByValuesDesc_spec_satisfied (input_dict : List (String × Int))
    (h_precond : SortDictByValuesDesc_precond input_dict) :
    SortDictByValuesDesc_postcond input_dict
      (SortDictByValuesDesc input_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof