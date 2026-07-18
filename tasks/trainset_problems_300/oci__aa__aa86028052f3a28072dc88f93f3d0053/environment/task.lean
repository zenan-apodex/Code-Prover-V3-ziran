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
    (h_precond : LongestPalindromicSubstring_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPalindromicString (t : String) : Prop :=
  t.toList = List.reverse (t.toList)

def IsSubstringOf (sub s : String) : Prop :=
  ∃ start len : Nat,
    start + len ≤ (s.toList).length ∧
    sub.toList = List.take len (List.drop start (s.toList))

def IsPalindromicSubstringOf (sub s : String) : Prop :=
  IsSubstringOf sub s ∧ IsPalindromicString sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindromicSubstring_postcond (s : String) (result : String)
    (h_precond : LongestPalindromicSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  IsPalindromicSubstringOf result s ∧
  (∀ t : String, IsPalindromicSubstringOf t s → (t.toList).length ≤ (result.toList).length)
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