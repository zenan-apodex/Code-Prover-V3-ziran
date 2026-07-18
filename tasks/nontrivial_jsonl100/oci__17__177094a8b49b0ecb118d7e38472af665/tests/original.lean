-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPalindrome (s : String) (h_precond : LongestPalindrome_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

def isSubstring (sub parent : List Char) : Prop :=
  ∃ i, i + sub.length ≤ parent.length ∧
    ∀ j, j < sub.length → sub[j]! = parent[i + j]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindrome_postcond (s : String) (result : String) (h_precond : LongestPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a palindrome
  isPalindrome rc ∧
  -- result is a contiguous substring of s
  isSubstring rc sc ∧
  -- result is the longest such palindrome: no palindromic substring of s is longer
  (∀ (t : List Char), isSubstring t sc → isPalindrome t → t.length ≤ rc.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindrome_spec_satisfied (s : String) (h_precond : LongestPalindrome_precond s) :
    LongestPalindrome_postcond s (LongestPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof