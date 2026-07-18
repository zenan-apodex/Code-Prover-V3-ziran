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

def isSubstringAt (sub : List Char) (s : List Char) (i : Nat) : Prop :=
  i + sub.length ≤ s.length ∧ (∀ j : Nat, j < sub.length → sub[j]! = s[i + j]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a palindrome
  isPalindrome rc ∧
  -- result is a substring of s
  (∃ i, isSubstringAt rc sc i) ∧
  -- no palindromic substring of s is longer than result
  (∀ sub : List Char, ∀ i : Nat,
    isSubstringAt sub sc i → isPalindrome sub → sub.length ≤ rc.length) ∧
  -- among all palindromic substrings of maximum length, result starts at the earliest position
  (∀ i : Nat, ∀ sub : List Char,
    isSubstringAt sub sc i → isPalindrome sub → sub.length = rc.length →
    ∃ j, isSubstringAt rc sc j ∧ j ≤ i)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof