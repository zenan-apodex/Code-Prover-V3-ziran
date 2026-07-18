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
/-- `IsSubseq sub l` means `sub` is a subsequence of `l` (preserving order, not necessarily contiguous). -/
def IsSubseq : List Int → List Int → Prop
  | [], _ => True
  | _ , [] => False
  | a :: as, b :: bs =>
    if a = b then IsSubseq as bs
    else IsSubseq (a :: as) bs

/-- A list is strictly increasing. -/
def StrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ StrictlyIncreasing (b :: rest)

/-- `IsIncreasingSubseqOf sub arr` means `sub` is a strictly increasing subsequence of `arr`. -/
def IsIncreasingSubseqOf (sub arr : List Int) : Prop :=
  IsSubseq sub arr ∧ StrictlyIncreasing sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestIncreasingSubsequence_postcond (arr : List Int) (result : Int) (h_precond : LongestIncreasingSubsequence_precond arr) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists an increasing subsequence of this length
  (∃ sub : List Int, IsIncreasingSubseqOf sub arr ∧ sub.length = result.toNat) ∧
  -- No increasing subsequence is longer
  (∀ sub : List Int, IsIncreasingSubseqOf sub arr → (sub.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestIncreasingSubsequence_spec_satisfied (arr : List Int) (h_precond : LongestIncreasingSubsequence_precond arr) :
    LongestIncreasingSubsequence_postcond arr (LongestIncreasingSubsequence arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof