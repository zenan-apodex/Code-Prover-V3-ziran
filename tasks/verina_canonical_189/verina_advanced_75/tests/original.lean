-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def task_code_precond (sequence : List Int) : Prop :=
  -- !benchmark @start precond
  sequence.length > 0  -- At least one element must be selected
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def task_code (sequence : List Int) (h_precond : task_code_precond (sequence)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def task_code_postcond (sequence : List Int) (result: Int) (h_precond : task_code_precond (sequence)) : Prop :=
  -- !benchmark @start postcond
  let subArrays :=
    List.range (sequence.length + 1) |>.flatMap (fun start =>
      List.range (sequence.length - start + 1) |>.map (fun len =>
        sequence.drop start |>.take len))
  let subArraySums := subArrays.filter (· ≠ []) |>.map (·.sum)
  subArraySums.contains result ∧ subArraySums.all (· ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem task_code_spec_satisfied (sequence: List Int) (h_precond : task_code_precond (sequence)) :
    task_code_postcond (sequence) (task_code (sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


