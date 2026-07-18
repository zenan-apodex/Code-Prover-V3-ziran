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
def substringChars (cs : List Char) (start len : Nat) : List Char :=
  (cs.drop start).take len

def IsUniqueSubstringOfLength (s : String) (len : Nat) : Prop :=
  let cs := s.toList
  ∃ start, start + len ≤ cs.length ∧ List.Nodup (substringChars cs start len)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLongestSubstring_postcond (s : String) (result : Int)
    (h_precond : LengthOfLongestSubstring_precond s) : Prop :=
  -- !benchmark @start postcond
  ∃ n : Nat,
    result = Int.ofNat n ∧
    IsUniqueSubstringOfLength s n ∧
    ∀ m : Nat, m > n → ¬ IsUniqueSubstringOfLength s m
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LengthOfLongestSubstring_spec_satisfied (s : String)
    (h_precond : LengthOfLongestSubstring_precond s) :
    LengthOfLongestSubstring_postcond s (LengthOfLongestSubstring s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof