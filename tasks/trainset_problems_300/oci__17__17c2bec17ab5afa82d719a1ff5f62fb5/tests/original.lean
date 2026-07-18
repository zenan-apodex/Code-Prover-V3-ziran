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


def LongestPalindromicSubstring (s : String)
    (h_precond : LongestPalindromicSubstring_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPalindromeList (cs : List Char) : Prop :=
  cs.reverse = cs

def SubstringChars (s : String) (start len : Nat) : List Char :=
  (s.toList.drop start).take len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : Int)
    (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  ∃ start len : Nat,
    start + len ≤ s.length ∧
    IsPalindromeList (SubstringChars s start len) ∧
    result = Int.ofNat len ∧
    ∀ start' len' : Nat,
      start' + len' ≤ s.length →
      IsPalindromeList (SubstringChars s start' len') →
      len' ≤ len
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LongestPalindromicSubstring_spec_satisfied (s : String)
    (h_precond : LongestPalindromicSubstring_precond s) :
    LongestPalindromicSubstring_postcond s
      (LongestPalindromicSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof