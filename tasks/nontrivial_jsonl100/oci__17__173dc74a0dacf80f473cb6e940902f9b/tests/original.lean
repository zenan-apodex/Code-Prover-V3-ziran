-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def FindLongestPalindromicSubstring_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def FindLongestPalindromicSubstring (s : String) (h_precond : FindLongestPalindromicSubstring_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def FLPS_isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

def FLPS_isSubstringAt (sub : List Char) (s : List Char) (pos : Nat) : Prop :=
  pos + sub.length ≤ s.length ∧ (s.drop pos).take sub.length = sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindLongestPalindromicSubstring_postcond (s : String) (result : String) (h_precond : FindLongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  -- result is a palindrome
  FLPS_isPalindrome rs ∧
  -- result is a substring of s
  (∃ pos, FLPS_isSubstringAt rs cs pos) ∧
  -- no longer palindromic substring exists
  (∀ sub_pos sub_len, sub_pos + sub_len ≤ cs.length →
    FLPS_isPalindrome ((cs.drop sub_pos).take sub_len) →
    sub_len ≤ rs.length) ∧
  -- among all palindromic substrings of the maximum length, result starts at the earliest position
  (∃ pos, FLPS_isSubstringAt rs cs pos ∧
    ∀ pos' : Nat, pos' < pos →
      ∀ sub_len : Nat, sub_len = rs.length →
        pos' + sub_len ≤ cs.length →
        ¬ FLPS_isPalindrome ((cs.drop pos').take sub_len))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem FindLongestPalindromicSubstring_spec_satisfied (s : String) (h_precond : FindLongestPalindromicSubstring_precond s) :
    FindLongestPalindromicSubstring_postcond s (FindLongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof