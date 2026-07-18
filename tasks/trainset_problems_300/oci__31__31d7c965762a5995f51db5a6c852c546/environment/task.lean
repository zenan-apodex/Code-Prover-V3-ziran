-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveDuplicates_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RemoveDuplicates (input_list : List Int) (h_precond : RemoveDuplicates_precond input_list) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive FirstOccurrenceDedup : List Int → List Int → List Int → Prop
| nil (seen : List Int) :
    FirstOccurrenceDedup seen [] []
| skip (seen : List Int) (x : Int) (xs ys : List Int)
    (h_seen : x ∈ seen)
    (h_rest : FirstOccurrenceDedup seen xs ys) :
    FirstOccurrenceDedup seen (x :: xs) ys
| keep (seen : List Int) (x : Int) (xs ys : List Int)
    (h_fresh : x ∉ seen)
    (h_rest : FirstOccurrenceDedup (x :: seen) xs ys) :
    FirstOccurrenceDedup seen (x :: xs) (x :: ys)
-- !benchmark @end postcond_aux


@[reducible, simp]
def RemoveDuplicates_postcond (input_list : List Int) (result : List Int)
    (h_precond : RemoveDuplicates_precond input_list) : Prop :=
  -- !benchmark @start postcond
  FirstOccurrenceDedup [] input_list result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RemoveDuplicates_spec_satisfied (input_list : List Int)
    (h_precond : RemoveDuplicates_precond input_list) :
    RemoveDuplicates_postcond input_list (RemoveDuplicates input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof