-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive ConsecutiveDedupRel : List Int → List Int → Prop where
  | nil :
      ConsecutiveDedupRel [] []
  | singleton (x : Int) :
      ConsecutiveDedupRel [x] [x]
  | skip (x : Int) (xs ys : List Int) :
      ConsecutiveDedupRel (x :: xs) ys →
      ConsecutiveDedupRel (x :: x :: xs) ys
  | keep (x y : Int) (xs ys : List Int) :
      x ≠ y →
      ConsecutiveDedupRel (y :: xs) ys →
      ConsecutiveDedupRel (x :: y :: xs) (x :: ys)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveConsecutiveDuplicates_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RemoveConsecutiveDuplicates (lst : List Int)
    (h_precond : RemoveConsecutiveDuplicates_precond lst) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def RemoveConsecutiveDuplicates_postcond (lst : List Int) (result : List Int)
    (h_precond : RemoveConsecutiveDuplicates_precond lst) : Prop :=
  -- !benchmark @start postcond
  ConsecutiveDedupRel lst result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RemoveConsecutiveDuplicates_spec_satisfied (lst : List Int)
    (h_precond : RemoveConsecutiveDuplicates_precond lst) :
    RemoveConsecutiveDuplicates_postcond lst
      (RemoveConsecutiveDuplicates lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof