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
/-- Check if a list of characters is a palindrome. -/
def isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

/-- Extract a substring as a list of characters from index `i` with length `len`. -/
def substringChars (cs : List Char) (i len : Nat) : List Char :=
  (cs.drop i).take len

/-- A substring (i, len) is valid if i + len ≤ cs.length. -/
def isValidSubstring (cs : List Char) (i len : Nat) : Prop :=
  i + len ≤ cs.length
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  -- result is a substring of s: there exists a starting index i such that
  -- extracting rs.length chars from position i gives rs
  (∃ i : Nat, isValidSubstring cs i rs.length ∧ substringChars cs i rs.length = rs) ∧
  -- result is a palindrome
  isPalindrome rs ∧
  -- result is the longest palindromic substring: no palindromic substring is longer
  (∀ j len : Nat, isValidSubstring cs j len → isPalindrome (substringChars cs j len) → len ≤ rs.length) ∧
  -- among all palindromic substrings of the same maximum length, result starts earliest
  (∀ j : Nat, isValidSubstring cs j rs.length → isPalindrome (substringChars cs j rs.length) →
    ∃ i : Nat, isValidSubstring cs i rs.length ∧ substringChars cs i rs.length = rs ∧ i ≤ j)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof