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
/-- A substring of `cs` starting at index `i` with length `len` has no duplicate characters. -/
def isNodupSubstring (cs : List Char) (i len : Nat) : Prop :=
  i + len ≤ cs.length ∧ (cs.drop i |>.take len).Nodup
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLongestSubstring_postcond (s : String) (result : Int) (h_precond : LengthOfLongestSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  result ≥ 0 ∧
  -- There exists a substring of this length with no repeating characters
  (∃ i : Nat, isNodupSubstring cs i result.toNat) ∧
  -- No longer substring has all distinct characters
  (∀ i len : Nat, isNodupSubstring cs i len → (len : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLongestSubstring_spec_satisfied (s : String) (h_precond : LengthOfLongestSubstring_precond s) :
    LengthOfLongestSubstring_postcond s (LengthOfLongestSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof