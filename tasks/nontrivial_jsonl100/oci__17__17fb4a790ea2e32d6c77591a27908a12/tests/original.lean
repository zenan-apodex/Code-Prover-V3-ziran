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


def LongestPalindromicSubstring (s : String) (h_precond : LongestPalindromicSubstring_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list is a palindrome if it equals its reverse -/
def isPalindrome (l : List Char) : Prop := l = l.reverse

/-- Extract a contiguous slice of length `len` starting at index `start` from a list -/
def sliceOf (l : List Char) (start len : Nat) : List Char :=
  (l.drop start).take len

/-- There exists a palindromic substring of the given length -/
def hasPalindromicSubstring (l : List Char) (len : Nat) : Prop :=
  ∃ start, start + len ≤ l.length ∧ isPalindrome (sliceOf l start len)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : Int) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  -- if the string is empty, result is 0
  (cs = [] → result = 0) ∧
  -- if the string is non-empty, result is at least 1
  (cs ≠ [] → result ≥ 1) ∧
  -- there exists a palindromic substring of length result
  hasPalindromicSubstring cs result.toNat ∧
  -- no palindromic substring is longer than result
  (∀ len : Nat, hasPalindromicSubstring cs len → (len : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof