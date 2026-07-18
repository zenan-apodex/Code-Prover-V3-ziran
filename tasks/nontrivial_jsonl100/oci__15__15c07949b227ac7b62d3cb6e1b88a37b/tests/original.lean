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
def isPalindrome (cs : List Char) : Prop :=
  cs = cs.reverse

def isSuffix (suffix whole : List Char) : Prop :=
  ∃ prefix_, whole = prefix_ ++ suffix
-- !benchmark @end postcond_aux


@[reducible, simp]
def ShortestPalindrome_postcond (s : String) (result : String) (h_precond : ShortestPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a palindrome
  isPalindrome rc ∧
  -- result ends with s (s is a suffix of result)
  isSuffix sc rc ∧
  -- result is the shortest such string: no shorter string is both a palindrome and has s as suffix
  (∀ t : List Char,
    isPalindrome t → isSuffix sc t → t.length ≥ rc.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem ShortestPalindrome_spec_satisfied (s : String) (h_precond : ShortestPalindrome_precond s) :
    ShortestPalindrome_postcond s (ShortestPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof