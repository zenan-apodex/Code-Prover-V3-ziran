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

def isSubstringAt (sub parent : List Char) (start : Nat) : Prop :=
  start + sub.length ≤ parent.length ∧
  ∀ k, k < sub.length → sub[k]! = parent[start + k]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindrome_postcond (s : String) (result : String) (h_precond : LongestPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  -- result is a palindrome
  isPalindrome rs ∧
  -- result is a substring of s
  (∃ start, isSubstringAt rs cs start) ∧
  -- no palindromic substring of s is longer than result
  (∀ start len,
    start + len ≤ cs.length →
    isPalindrome (cs.drop start |>.take len) →
    len ≤ rs.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindrome_spec_satisfied (s : String) (h_precond : LongestPalindrome_precond s) :
    LongestPalindrome_postcond s (LongestPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof