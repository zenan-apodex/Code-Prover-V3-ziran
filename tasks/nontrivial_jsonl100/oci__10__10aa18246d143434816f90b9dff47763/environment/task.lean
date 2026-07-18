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
/-- A substring of `cs` starting at index `i` with length `len` has all distinct characters. -/
def isDistinctSubstring (cs : List Char) (i len : Nat) : Prop :=
  i + len ≤ cs.length ∧ (List.drop i (List.take (i + len) cs)).Nodup

/-- There exists a substring of length `len` with all distinct characters. -/
def hasDistinctSubstringOfLength (cs : List Char) (len : Nat) : Prop :=
  ∃ i, isDistinctSubstring cs i len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLongestSubstring_postcond (s : String) (result : Int) (h_precond : LengthOfLongestSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let n := result.toNat
  result ≥ 0 ∧
  -- result is achievable: there exists a substring of this length with all distinct chars
  hasDistinctSubstringOfLength cs n ∧
  -- result is maximal: no longer substring has all distinct chars
  (∀ m : Nat, m > n → ¬ hasDistinctSubstringOfLength cs m)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLongestSubstring_spec_satisfied (s : String) (h_precond : LengthOfLongestSubstring_precond s) :
    LengthOfLongestSubstring_postcond s (LengthOfLongestSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof