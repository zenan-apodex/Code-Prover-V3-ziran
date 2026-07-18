-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestSubstringWithKDistinct_precond (s : String) (k : Int) : Prop :=
  -- !benchmark @start precond
  k ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestSubstringWithKDistinct (s : String) (k : Int) (h_precond : LongestSubstringWithKDistinct_precond s k) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- The number of distinct characters in a list -/
def distinctCount (cs : List Char) : Nat :=
  cs.eraseDups.length

/-- Extract a substring as a list of chars: take `len` chars starting at `start` -/
def substringChars (cs : List Char) (start len : Nat) : List Char :=
  (cs.drop start).take len
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestSubstringWithKDistinct_postcond (s : String) (k : Int) (result : String) (h_precond : LongestSubstringWithKDistinct_precond s k) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  let rs := result.toList
  let kn := Int.toNat k
  -- result is a contiguous substring of s with at most k distinct characters
  (∃ start : Nat, start + rs.length ≤ cs.length ∧
    rs = substringChars cs start rs.length ∧
    distinctCount rs ≤ kn ∧
    -- result is the longest such substring
    (∀ (s2 : Nat) (l2 : Nat), s2 + l2 ≤ cs.length →
      distinctCount (substringChars cs s2 l2) ≤ kn →
      l2 ≤ rs.length) ∧
    -- among all substrings of the same maximum length, this one starts earliest
    (∀ (s2 : Nat) (l2 : Nat), s2 + l2 ≤ cs.length →
      distinctCount (substringChars cs s2 l2) ≤ kn →
      l2 = rs.length →
      start ≤ s2))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestSubstringWithKDistinct_spec_satisfied (s : String) (k : Int) (h_precond : LongestSubstringWithKDistinct_precond s k) :
    LongestSubstringWithKDistinct_postcond s k (LongestSubstringWithKDistinct s k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof