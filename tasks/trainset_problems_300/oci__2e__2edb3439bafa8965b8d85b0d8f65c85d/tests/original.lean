-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ConvertValuesToUppercase_precond (input_dict : List (String × String)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) input_dict
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ConvertValuesToUppercase (input_dict : List (String × String))
    (h_precond : ConvertValuesToUppercase_precond input_dict) : List (String × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def ConvertValuesToUppercase_postcond (input_dict : List (String × String))
    (result : List (String × String))
    (h_precond : ConvertValuesToUppercase_precond input_dict) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ input_dict, ∃ q ∈ result, q.1 = p.1 ∧ q.2 = p.2.toUpper) ∧
  (∀ q ∈ result, ∃ p ∈ input_dict, q.1 = p.1 ∧ q.2 = p.2.toUpper)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ConvertValuesToUppercase_spec_satisfied (input_dict : List (String × String))
    (h_precond : ConvertValuesToUppercase_precond input_dict) :
    ConvertValuesToUppercase_postcond input_dict
      (ConvertValuesToUppercase input_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof