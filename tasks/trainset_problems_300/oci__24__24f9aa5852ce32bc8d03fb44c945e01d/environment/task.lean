-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountUniqueElements_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountUniqueElements (lst : List Int) (h_precond : CountUniqueElements_precond lst) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountUniqueElements_postcond (lst : List Int) (result : Int)
    (h_precond : CountUniqueElements_precond lst) : Prop :=
  -- !benchmark @start postcond
  ∃ us : List Int,
    us.Nodup ∧
    (∀ x : Int, x ∈ lst ↔ x ∈ us) ∧
    result = us.length
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountUniqueElements_spec_satisfied (lst : List Int)
    (h_precond : CountUniqueElements_precond lst) :
    CountUniqueElements_postcond lst (CountUniqueElements lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof