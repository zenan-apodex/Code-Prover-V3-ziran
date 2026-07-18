-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

-- A helper to define "subsequence" relation on lists of characters
-- !benchmark @start postcond_aux
def IsSubseq : List Char → List Char → Prop
  | [], _ => True
  | _, [] => False
  | a :: as, b :: bs =>
    if a = b then IsSubseq as bs
    else IsSubseq (a :: as) bs
-- !benchmark @end postcond_aux

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


@[reducible, simp]
def LongestCommonSubsequence_postcond (X : String) (Y : String) (result : String) (h_precond : LongestCommonSubsequence_precond X Y) : Prop :=
  -- !benchmark @start postcond
  let xs := X.toList
  let ys := Y.toList
  let rs := result.toList
  -- result is a subsequence of X
  IsSubseq rs xs ∧
  -- result is a subsequence of Y
  IsSubseq rs ys ∧
  -- result is longest: no common subsequence is strictly longer
  (∀ (s : List Char), IsSubseq s xs → IsSubseq s ys → s.length ≤ rs.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonSubsequence_spec_satisfied (X : String) (Y : String) (h_precond : LongestCommonSubsequence_precond X Y) :
    LongestCommonSubsequence_postcond X Y (LongestCommonSubsequence X Y h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof