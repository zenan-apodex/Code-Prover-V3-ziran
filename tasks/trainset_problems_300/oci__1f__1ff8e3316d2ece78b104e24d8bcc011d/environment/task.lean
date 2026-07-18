-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountUniqueElements_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountUniqueElements (input_list : List Int)
    (h_precond : CountUniqueElements_precond input_list) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountUniqueElements_postcond (input_list : List Int) (result : Int)
    (h_precond : CountUniqueElements_precond input_list) : Prop :=
  -- !benchmark @start postcond
  ∃ uniques : List Int,
    uniques.Nodup ∧
    (∀ x : Int, x ∈ uniques ↔ x ∈ input_list) ∧
    result = Int.ofNat uniques.length
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountUniqueElements_spec_satisfied (input_list : List Int)
    (h_precond : CountUniqueElements_precond input_list) :
    CountUniqueElements_postcond input_list
      (CountUniqueElements input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof