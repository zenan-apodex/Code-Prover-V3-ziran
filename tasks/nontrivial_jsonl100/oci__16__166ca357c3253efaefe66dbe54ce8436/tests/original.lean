-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPalindrome (s : String) (h_precond : LongestPalindrome_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list is a palindrome iff it equals its reverse. -/
def isPalindromeList (cs : List Char) : Prop := cs = cs.reverse

/-- `cs` is a contiguous substring of `parent` starting at index `i`. -/
def isSubstrAt (cs : List Char) (i : Nat) (parent : List Char) : Prop :=
  i + cs.length ≤ parent.length ∧ cs = (parent.drop i).take cs.length

/-- `cs` occurs as a contiguous substring of `parent`. -/
def isSubstrOf (cs : List Char) (parent : List Char) : Prop :=
  ∃ i, isSubstrAt cs i parent

/-- The earliest starting index of `cs` in `parent`, or 0 if not found.
    We define it computationally so Lean can evaluate it. -/
def earliestStartIdx (cs : List Char) (parent : List Char) : Nat :=
  let n := parent.length
  let go : Nat → Nat := fun start =>
    start  -- dummy, we define via List.findIdx below
  -- We search for the first index i in [0..n] such that (parent.drop i).take cs.length == cs
  let indices := List.range (n + 1)
  match indices.find? (fun i => (parent.drop i).take cs.length == cs && i + cs.length ≤ n) with
  | some i => i
  | none => 0
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPalindrome_postcond (s : String) (result : String) (h_precond : LongestPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let sc := s.toList
  let rc := result.toList
  -- result is a contiguous substring of s
  isSubstrOf rc sc ∧
  -- result is a palindrome
  isPalindromeList rc ∧
  -- no palindromic substring of s is longer than result
  (∀ (t : List Char), isSubstrOf t sc → isPalindromeList t → t.length ≤ rc.length) ∧
  -- among all palindromic substrings of the same maximum length, result starts earliest
  (∀ (t : List Char) (j : Nat), isSubstrAt t j sc → isPalindromeList t → t.length = rc.length →
    earliestStartIdx rc sc ≤ j)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPalindrome_spec_satisfied (s : String) (h_precond : LongestPalindrome_precond s) :
    LongestPalindrome_postcond s (LongestPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof