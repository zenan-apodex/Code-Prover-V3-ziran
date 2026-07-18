-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestPalindromicSubseq_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPalindromicSubseq (s : String) (h_precond : LongestPalindromicSubseq_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseq sub lst` means `sub` is a subsequence of `lst` (preserving order, not necessarily contiguous). -/
def IsSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ :: _, [] => False
  | a :: as, b :: bs =>
    if a = b then IsSubseq as bs
    else IsSubseq (a :: as) bs

/-- A list is a palindrome if it equals its reverse. -/
def IsPalindrome (l : List Char) : Prop :=
  l = l.reverse

-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubseq_postcond (s : String) (result : Int) (h_precond : LongestPalindromicSubseq_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  result ≤ cs.length ∧
  -- There exists a palindromic subsequence of cs whose deletion count equals result
  (∃ sub : List Char, IsSubseq sub cs ∧ IsPalindrome sub ∧ (cs.length - sub.length : Int) = result) ∧
  -- result is minimal: no palindromic subsequence has fewer deletions (i.e., greater length)
  (∀ sub : List Char, IsSubseq sub cs → IsPalindrome sub → sub.length ≤ cs.length - result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubseq_spec_satisfied (s : String) (h_precond : LongestPalindromicSubseq_precond s) :
    LongestPalindromicSubseq_postcond s (LongestPalindromicSubseq s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof