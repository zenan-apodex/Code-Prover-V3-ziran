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
def isPalindrome (l : List Char) : Prop :=
  l = l.reverse

def isSublist (sub lst : List Char) (start len : Nat) : Prop :=
  start + len ≤ lst.length ∧ sub = (lst.drop start).take len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : Int) (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  result ≥ 0 ∧
  -- There exists a palindromic substring of this length
  (∃ start len : Nat, len = result.toNat ∧
    isSublist ((cs.drop start).take len) cs start len ∧
    isPalindrome ((cs.drop start).take len)) ∧
  -- No palindromic substring is longer
  (∀ start len : Nat,
    isSublist ((cs.drop start).take len) cs start len →
    isPalindrome ((cs.drop start).take len) →
    (len : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof