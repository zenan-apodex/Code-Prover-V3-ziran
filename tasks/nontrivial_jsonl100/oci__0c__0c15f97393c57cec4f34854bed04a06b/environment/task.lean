-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestIncreasingSubsequence_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestIncreasingSubsequence (arr : List Int) (h_precond : LongestIncreasingSubsequence_precond arr) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list `sub` is a subsequence of `xs` -/
def IsSubseqOf (sub xs : List Int) : Prop :=
  match sub with
  | [] => True
  | s :: ss =>
    match xs with
    | [] => False
    | x :: rest =>
      (s = x ∧ IsSubseqOf ss rest) ∨ IsSubseqOf (s :: ss) rest

/-- A list is strictly increasing -/
def StrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ StrictlyIncreasing (b :: rest)

/-- An increasing subsequence of `arr` of length `n` -/
def HasIncreasingSubseqOfLength (arr : List Int) (n : Nat) : Prop :=
  ∃ sub : List Int, IsSubseqOf sub arr ∧ StrictlyIncreasing sub ∧ sub.length = n
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestIncreasingSubsequence_postcond (arr : List Int) (result : Nat) (h_precond : LongestIncreasingSubsequence_precond arr) : Prop :=
  -- !benchmark @start postcond
  -- There exists an increasing subsequence of this length
  HasIncreasingSubseqOfLength arr result ∧
  -- No increasing subsequence is longer
  (∀ m : Nat, HasIncreasingSubseqOfLength arr m → m ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestIncreasingSubsequence_spec_satisfied (arr : List Int) (h_precond : LongestIncreasingSubsequence_precond arr) :
    LongestIncreasingSubsequence_postcond arr (LongestIncreasingSubsequence arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof