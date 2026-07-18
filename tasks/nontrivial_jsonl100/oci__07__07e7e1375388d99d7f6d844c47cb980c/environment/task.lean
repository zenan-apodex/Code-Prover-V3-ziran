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
def isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

def isSubstring (sub : List Char) (s : List Char) : Prop :=
  ∃ i, i + sub.length ≤ s.length ∧ sub = (s.drop i).take sub.length
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : Int) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a palindromic substring of that length
  (∃ sub : List Char, isSubstring sub cs ∧ isPalindrome sub ∧ sub.length = result.toNat) ∧
  -- no palindromic substring is longer
  (∀ sub : List Char, isSubstring sub cs → isPalindrome sub → sub.length ≤ result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof