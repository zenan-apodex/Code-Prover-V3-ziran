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
/-- A list is a palindrome if it equals its reverse. -/
def isPalindrome (cs : List Char) : Prop := cs = cs.reverse

/-- `sub` is a contiguous substring (sublist) of `parent` starting at index `i` with length `len`. -/
def isSubstringAt (parent : List Char) (sub : List Char) (i : Nat) : Prop :=
  i + sub.length ≤ parent.length ∧ sub = (parent.drop i).take sub.length

/-- `sub` is a contiguous substring of `parent`. -/
def isContiguousSubstring (parent : List Char) (sub : List Char) : Prop :=
  ∃ i, isSubstringAt parent sub i
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  -- result is a palindrome
  isPalindrome rs ∧
  -- result is a contiguous substring of s
  isContiguousSubstring cs rs ∧
  -- result is the longest such palindrome: no palindromic contiguous substring of s is longer
  (∀ (other : List Char),
    isContiguousSubstring cs other → isPalindrome other → other.length ≤ rs.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof