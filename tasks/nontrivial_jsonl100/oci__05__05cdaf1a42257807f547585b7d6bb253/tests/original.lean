-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MinDeletionsToPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MinDeletionsToPalindrome (s : String) (h_precond : MinDeletionsToPalindrome_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list is a subsequence of another list -/
def IsSubsequence : List Char → List Char → Prop
  | [], _ => True
  | _, [] => False
  | a :: as, b :: bs =>
    (a = b ∧ IsSubsequence as bs) ∨ IsSubsequence (a :: as) bs

/-- A list is a palindrome -/
def IsPalindrome (l : List Char) : Prop :=
  l = l.reverse

/-- A list is a palindromic subsequence of another list -/
def IsPalindromicSubseq (sub parent : List Char) : Prop :=
  IsSubsequence sub parent ∧ IsPalindrome sub

/-- The minimum number of deletions to make a list a palindrome equals
    length - longest palindromic subsequence length -/
def MinDelPalin (cs : List Char) (k : Int) : Prop :=
  -- k is the minimum number of deletions
  -- There exists a palindromic subsequence of length (cs.length - k)
  (∃ sub : List Char, IsPalindromicSubseq sub cs ∧ sub.length = cs.length - k.toNat) ∧
  -- k is non-negative
  k ≥ 0 ∧
  k ≤ cs.length ∧
  -- No palindromic subsequence is longer than (cs.length - k)
  (∀ sub : List Char, IsPalindromicSubseq sub cs → sub.length ≤ cs.length - k.toNat)
-- !benchmark @end postcond_aux


@[reducible, simp]
def MinDeletionsToPalindrome_postcond (s : String) (result : Int) (h_precond : MinDeletionsToPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  MinDelPalin s.toList result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MinDeletionsToPalindrome_spec_satisfied (s : String) (h_precond : MinDeletionsToPalindrome_precond s) :
    MinDeletionsToPalindrome_postcond s (MinDeletionsToPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof