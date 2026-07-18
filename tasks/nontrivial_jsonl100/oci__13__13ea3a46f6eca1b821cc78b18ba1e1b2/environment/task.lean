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


def LongestIncreasingSubsequence (arr : List Int) (h_precond : LongestIncreasingSubsequence_precond arr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsStrictlyIncreasing` checks that a list is strictly increasing. -/
def IsStrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ IsStrictlyIncreasing (b :: rest)

/-- `IsSubsequenceOf sub lst` means `sub` can be obtained by deleting
    elements from `lst` while preserving order. -/
def IsSubsequenceOf : List Int → List Int → Prop
  | [], _ => True
  | _ :: _, [] => False
  | a :: as', b :: bs' =>
    (a = b ∧ IsSubsequenceOf as' bs') ∨ IsSubsequenceOf (a :: as') bs'
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestIncreasingSubsequence_postcond (arr : List Int) (result : Int) (h_precond : LongestIncreasingSubsequence_precond arr) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists a strictly increasing subsequence of `arr` with length `result`
  (∃ sub : List Int,
    IsSubsequenceOf sub arr ∧
    IsStrictlyIncreasing sub ∧
    sub.length = result.toNat) ∧
  -- No strictly increasing subsequence of `arr` has length greater than `result`
  (∀ sub : List Int,
    IsSubsequenceOf sub arr →
    IsStrictlyIncreasing sub →
    (sub.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestIncreasingSubsequence_spec_satisfied (arr : List Int) (h_precond : LongestIncreasingSubsequence_precond arr) :
    LongestIncreasingSubsequence_postcond arr (LongestIncreasingSubsequence arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof