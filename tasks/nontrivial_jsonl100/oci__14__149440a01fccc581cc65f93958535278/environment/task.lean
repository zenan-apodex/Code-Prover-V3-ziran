-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestCommonSubstring_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestCommonSubstring (s1 : String) (s2 : String) (h_precond : LongestCommonSubstring_precond s1 s2) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A substring of `s` starting at index `start` with length `len` (on the list of characters). -/
def substringAt (s : List Char) (start len : Nat) : List Char :=
  (s.drop start).take len

/-- Predicate: `sub` is a contiguous substring of `s` (as lists of chars). -/
def isSubstringOf (sub s : List Char) : Prop :=
  ∃ start, start + sub.length ≤ s.length ∧ substringAt s start sub.length = sub

/-- Predicate: `sub` occurs in `s` starting at position `start`. -/
def isSubstringAt (sub s : List Char) (start : Nat) : Prop :=
  start + sub.length ≤ s.length ∧ substringAt s start sub.length = sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestCommonSubstring_postcond (s1 : String) (s2 : String) (result : String) (h_precond : LongestCommonSubstring_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  let cs1 := s1.toList
  let cs2 := s2.toList
  let cr := result.toList
  -- result is a common substring of both s1 and s2
  isSubstringOf cr cs1 ∧
  isSubstringOf cr cs2 ∧
  -- no common substring is longer
  (∀ sub : List Char, isSubstringOf sub cs1 → isSubstringOf sub cs2 → sub.length ≤ cr.length) ∧
  -- among all common substrings of maximum length, result starts at the earliest position in s1
  (∃ startR, isSubstringAt cr cs1 startR ∧
    ∀ sub : List Char, ∀ startS : Nat,
      isSubstringAt sub cs1 startS →
      isSubstringOf sub cs2 →
      sub.length = cr.length →
      startR ≤ startS)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonSubstring_spec_satisfied (s1 : String) (s2 : String) (h_precond : LongestCommonSubstring_precond s1 s2) :
    LongestCommonSubstring_postcond s1 s2 (LongestCommonSubstring s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof