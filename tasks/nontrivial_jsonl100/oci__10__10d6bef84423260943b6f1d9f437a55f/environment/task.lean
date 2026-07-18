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

def isContiguousSublist (sub whole : List Char) : Prop :=
  ∃ i, i + sub.length ≤ whole.length ∧
    ∀ j, j < sub.length → sub[j]! = whole[i + j]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a palindrome
  isPalindrome rc ∧
  -- result is a contiguous substring of s
  isContiguousSublist rc sc ∧
  -- no longer palindromic contiguous substring exists
  (∀ (t : List Char),
    isContiguousSublist t sc → isPalindrome t → t.length ≤ rc.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof