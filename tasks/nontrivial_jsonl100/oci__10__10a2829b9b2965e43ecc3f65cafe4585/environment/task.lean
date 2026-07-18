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
def isSubstringSlice (cs : List Char) (sub : List Char) : Prop :=
  ∃ i, i + sub.length ≤ cs.length ∧ sub = (cs.drop i).take sub.length

def hasNoDuplicates (xs : List Char) : Prop :=
  xs.Nodup
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLongestSubstring_postcond (s : String) (result : Int) (h_precond : LengthOfLongestSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a substring of that length with no duplicates
  (∃ sub : List Char, isSubstringSlice cs sub ∧ hasNoDuplicates sub ∧ sub.length = result.toNat) ∧
  -- no substring without duplicates is longer than result
  (∀ sub : List Char, isSubstringSlice cs sub → hasNoDuplicates sub → sub.length ≤ result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLongestSubstring_spec_satisfied (s : String) (h_precond : LengthOfLongestSubstring_precond s) :
    LengthOfLongestSubstring_postcond s (LengthOfLongestSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof