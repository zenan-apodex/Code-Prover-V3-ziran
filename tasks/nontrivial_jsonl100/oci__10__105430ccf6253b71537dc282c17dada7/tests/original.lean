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
  s.length ≤ 1000 ∧ (∀ c ∈ s.toList, c.isLower)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPalindromicSubstring (s : String) (h_precond : LongestPalindromicSubstring_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list is a palindrome if it equals its reverse. -/
def isPalindrome (cs : List Char) : Prop := cs = cs.reverse

/-- `sub` is a contiguous substring of `parent` (as lists of chars). -/
def isContiguousSubstring (sub parent : List Char) : Prop :=
  ∃ i, i + sub.length ≤ parent.length ∧ sub = (parent.drop i).take sub.length
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String)
    (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a palindrome
  isPalindrome rc ∧
  -- result is a contiguous substring of s
  isContiguousSubstring rc sc ∧
  -- no palindromic contiguous substring of s is longer than result
  (∀ (t : List Char),
    isContiguousSubstring t sc → isPalindrome t → t.length ≤ rc.length) ∧
  -- if s is empty, result is empty
  (s.toList = [] → rc = [])
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String)
    (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof