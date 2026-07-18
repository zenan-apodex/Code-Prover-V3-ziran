-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LengthOfLongestSubstring_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLongestSubstring (s : String) (h_precond : LengthOfLongestSubstring_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list has all unique (distinct) elements -/
def allUnique (l : List Char) : Prop :=
  l.Nodup

/-- Extract a substring (as a list of chars) starting at index `start` with length `len` -/
def substringSlice (cs : List Char) (start len : Nat) : List Char :=
  (cs.drop start).take len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLongestSubstring_postcond (s : String) (result : Int) (h_precond : LengthOfLongestSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.data
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a substring of that length with all unique characters
  (∃ start : Nat, start + result.toNat ≤ cs.length ∧
    allUnique (substringSlice cs start result.toNat)) ∧
  -- no longer substring has all unique characters
  (∀ len : Nat, len > result.toNat →
    ∀ start : Nat, start + len ≤ cs.length →
      ¬ allUnique (substringSlice cs start len))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLongestSubstring_spec_satisfied (s : String) (h_precond : LengthOfLongestSubstring_precond s) :
    LengthOfLongestSubstring_postcond s (LengthOfLongestSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof