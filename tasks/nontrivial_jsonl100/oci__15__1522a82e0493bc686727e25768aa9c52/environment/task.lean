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
/-- A list is a palindrome iff it equals its reverse. -/
def isPalindrome (cs : List Char) : Prop := cs = cs.reverse

/-- `isSubstringAt cs i len parent` means `parent[i..i+len)` equals `cs`. -/
def isSubstringAt (cs : List Char) (i len : Nat) (parent : List Char) : Prop :=
  i + len ≤ parent.length ∧ cs = (parent.drop i).take len ∧ cs.length = len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is empty iff s is empty
  (sc = [] → rc = []) ∧
  -- result is a palindrome
  isPalindrome rc ∧
  -- result is a contiguous substring of s
  (∃ i, isSubstringAt rc i rc.length sc) ∧
  -- no palindromic substring of s is longer than result
  (∀ j len, j + len ≤ sc.length →
    isPalindrome ((sc.drop j).take len) →
    len ≤ rc.length) ∧
  -- among all palindromic substrings of maximum length, result starts earliest
  (∀ j, j + rc.length ≤ sc.length →
    isPalindrome ((sc.drop j).take rc.length) →
    ∃ i, isSubstringAt rc i rc.length sc ∧ i ≤ j)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof