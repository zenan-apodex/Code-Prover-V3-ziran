-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestCommonSubsequence_precond (X : String) (Y : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestCommonSubsequence (X : String) (Y : String) (h_precond : LongestCommonSubsequence_precond X Y) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseq xs ys` holds when `xs` is a subsequence of `ys`. -/
def IsSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ , [] => False
  | x :: xs, y :: ys =>
    if x = y then IsSubseq xs ys
    else IsSubseq (x :: xs) ys
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestCommonSubsequence_postcond (X : String) (Y : String) (result : String) (h_precond : LongestCommonSubsequence_precond X Y) : Prop :=
  -- !benchmark @start postcond
  let rx := X.toList
  let ry := Y.toList
  let rr := result.toList
  -- result is a common subsequence of X and Y
  IsSubseq rr rx ∧
  IsSubseq rr ry ∧
  -- result has maximum length among all common subsequences
  (∀ s : List Char, IsSubseq s rx → IsSubseq s ry → s.length ≤ rr.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonSubsequence_spec_satisfied (X : String) (Y : String) (h_precond : LongestCommonSubsequence_precond X Y) :
    LongestCommonSubsequence_postcond X Y (LongestCommonSubsequence X Y h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof