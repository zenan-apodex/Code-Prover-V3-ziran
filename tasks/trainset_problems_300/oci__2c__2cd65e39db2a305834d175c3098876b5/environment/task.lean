-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def OptimizeList_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def OptimizeList (input_list : List Int) (h_precond : OptimizeList_precond input_list) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive OptimizeListRel : List Int → List Int → List Int → Prop where
  | nil (seen : List Int) :
      OptimizeListRel seen [] []
  | skip (seen : List Int) (x : Int) (xs ys : List Int) :
      x ∈ seen →
      OptimizeListRel seen xs ys →
      OptimizeListRel seen (x :: xs) ys
  | keep (seen : List Int) (x : Int) (xs ys : List Int) :
      x ∉ seen →
      OptimizeListRel (x :: seen) xs ys →
      OptimizeListRel seen (x :: xs) (x :: ys)
-- !benchmark @end postcond_aux


@[reducible, simp]
def OptimizeList_postcond (input_list : List Int) (result : List Int)
    (h_precond : OptimizeList_precond input_list) : Prop :=
  -- !benchmark @start postcond
  OptimizeListRel [] input_list result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem OptimizeList_spec_satisfied (input_list : List Int)
    (h_precond : OptimizeList_precond input_list) :
    OptimizeList_postcond input_list (OptimizeList input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof