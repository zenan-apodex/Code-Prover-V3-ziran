-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MinInsertionsToPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MinInsertionsToPalindrome (s : String) (h_precond : MinInsertionsToPalindrome_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list is a palindrome -/
def isPalindrome (l : List Char) : Prop := l = l.reverse

/-- `sub` is a subsequence of `sup` -/
def isSubsequence : List Char → List Char → Prop
  | [], _ => True
  | _, [] => False
  | a :: as, b :: bs =>
    if a = b then isSubsequence as bs
    else isSubsequence (a :: as) bs

/-- `t` is a supersequence of `s` that is a palindrome with length `s.length + k` -/
def isPalindromicSupersequence (s t : List Char) : Prop :=
  isSubsequence s t ∧ isPalindrome t
-- !benchmark @end postcond_aux


@[reducible, simp]
def MinInsertionsToPalindrome_postcond (s : String) (result : Int) (h_precond : MinInsertionsToPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a palindromic supersequence of s with exactly s.length + result characters
  (∃ t : List Char, isPalindromicSupersequence cs t ∧ t.length = cs.length + result.toNat) ∧
  -- result is minimal: no palindromic supersequence of s has fewer than s.length + result characters
  (∀ t : List Char, isPalindromicSupersequence cs t → t.length ≥ cs.length + result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MinInsertionsToPalindrome_spec_satisfied (s : String) (h_precond : MinInsertionsToPalindrome_precond s) :
    MinInsertionsToPalindrome_postcond s (MinInsertionsToPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof