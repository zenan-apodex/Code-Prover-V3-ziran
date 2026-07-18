-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestCommonSubsequence_precond (str1 : String) (str2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestCommonSubsequence (str1 : String) (str2 : String) (h_precond : LongestCommonSubsequence_precond str1 str2) : Nat × String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseq xs ys` means `xs` is a subsequence of `ys` (as lists of characters). -/
def IsSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ :: _, [] => False
  | x :: xs, y :: ys =>
    if x = y then IsSubseq xs ys
    else IsSubseq (x :: xs) ys
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestCommonSubsequence_postcond (str1 : String) (str2 : String) (result : Nat × String) (h_precond : LongestCommonSubsequence_precond str1 str2) : Prop :=
  -- !benchmark @start postcond
  let (len, lcs) := result
  let s1 := str1.toList
  let s2 := str2.toList
  let lcsChars := lcs.toList
  -- The length matches the LCS string length
  len = lcsChars.length ∧
  -- The LCS is a subsequence of both strings
  IsSubseq lcsChars s1 ∧
  IsSubseq lcsChars s2 ∧
  -- No common subsequence is longer
  (∀ (cs : List Char), IsSubseq cs s1 → IsSubseq cs s2 → cs.length ≤ len)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonSubsequence_spec_satisfied (str1 : String) (str2 : String) (h_precond : LongestCommonSubsequence_precond str1 str2) :
    LongestCommonSubsequence_postcond str1 str2 (LongestCommonSubsequence str1 str2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof