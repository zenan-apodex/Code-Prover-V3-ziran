-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ProcessData_precond (data : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ProcessData (data : List Int) (h_precond : ProcessData_precond data) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def ProcessData_postcond (data : List Int) (result : List Int)
    (h_precond : ProcessData_precond data) : Prop :=
  -- !benchmark @start postcond
  List.Forall₂ (fun x y => y = x * x + 5) data result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ProcessData_spec_satisfied (data : List Int) (h_precond : ProcessData_precond data) :
    ProcessData_postcond data (ProcessData data h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof