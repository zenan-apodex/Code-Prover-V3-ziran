-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveOccurrences_precond (lst : List Int) (value : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RemoveOccurrences (lst : List Int) (value : Int)
    (h_precond : RemoveOccurrences_precond lst value) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def RemoveOccurrences_postcond (lst : List Int) (value : Int) (result : List Int)
    (h_precond : RemoveOccurrences_precond lst value) : Prop :=
  -- !benchmark @start postcond
  List.Sublist result lst ∧
    ∀ x : Int, result.count x = if x = value then 0 else lst.count x
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RemoveOccurrences_spec_satisfied (lst : List Int) (value : Int)
    (h_precond : RemoveOccurrences_precond lst value) :
    RemoveOccurrences_postcond lst value (RemoveOccurrences lst value h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof