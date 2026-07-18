-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SquareValues_precond (input_dict : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) input_dict
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SquareValues (input_dict : List (String × Int)) (h_precond : SquareValues_precond input_dict) :
    List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SquareValues_postcond (input_dict : List (String × Int)) (result : List (String × Int))
    (h_precond : SquareValues_precond input_dict) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ input_dict, ∃ q ∈ result, q.1 = p.1 ∧ q.2 = p.2 * p.2) ∧
  (∀ q ∈ result, ∃ p ∈ input_dict, q.1 = p.1 ∧ q.2 = p.2 * p.2)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SquareValues_spec_satisfied (input_dict : List (String × Int))
    (h_precond : SquareValues_precond input_dict) :
    SquareValues_postcond input_dict (SquareValues input_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof