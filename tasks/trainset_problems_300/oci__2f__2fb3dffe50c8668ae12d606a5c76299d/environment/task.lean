-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ShortestPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ShortestPalindrome (s : String) (h_precond : ShortestPalindrome_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPalindromeChars (cs : List Char) : Prop :=
  cs.reverse = cs
-- !benchmark @end postcond_aux


@[reducible, simp]
def ShortestPalindrome_postcond (s : String) (result : String)
    (h_precond : ShortestPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  (∃ added : List Char, result.toList = added ++ s.toList) ∧
  IsPalindromeChars result.toList ∧
  (∀ added' : List Char,
    IsPalindromeChars (added' ++ s.toList) →
    result.toList.length ≤ (added' ++ s.toList).length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ShortestPalindrome_spec_satisfied (s : String)
    (h_precond : ShortestPalindrome_precond s) :
    ShortestPalindrome_postcond s (ShortestPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof