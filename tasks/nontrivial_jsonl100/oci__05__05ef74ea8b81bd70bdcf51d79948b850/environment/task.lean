-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestPalindromicSubstring_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPalindromicSubstring (s : String) (h_precond : LongestPalindromicSubstring_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

def isSubstringAt (sub parent : List Char) (start : Nat) : Prop :=
  start + sub.length ≤ parent.length ∧
  sub = (parent.drop start).take sub.length
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  -- result is a palindrome
  isPalindrome rs ∧
  -- result is a substring of s
  (∃ start, isSubstringAt rs cs start) ∧
  -- no longer palindromic substring exists
  (∀ (sub : List Char) (start : Nat),
    isSubstringAt sub cs start → isPalindrome sub → sub.length ≤ rs.length) ∧
  -- among palindromic substrings of the same maximum length, result appears first
  (∀ (sub : List Char) (start2 : Nat),
    isSubstringAt sub cs start2 → isPalindrome sub → sub.length = rs.length →
    ∃ start1, isSubstringAt rs cs start1 ∧ start1 ≤ start2)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof