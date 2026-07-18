-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestIncreasingSubsequence_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestIncreasingSubsequence (nums : List Int) (h_precond : LongestIncreasingSubsequence_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseqOf sub l` means `sub` is a subsequence of `l` (preserving order). -/
def IsSubseqOf : List Int → List Int → Prop
  | [], _ => True
  | _ , [] => False
  | a :: as, b :: bs =>
    (a = b ∧ IsSubseqOf as bs) ∨ IsSubseqOf (a :: as) bs

/-- A list is strictly increasing. -/
def StrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ StrictlyIncreasing (b :: rest)

/-- `IsIncreasingSubseqOf sub nums` means `sub` is a strictly increasing subsequence of `nums`. -/
def IsIncreasingSubseqOf (sub nums : List Int) : Prop :=
  IsSubseqOf sub nums ∧ StrictlyIncreasing sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestIncreasingSubsequence_postcond (nums : List Int) (result : Int) (h_precond : LongestIncreasingSubsequence_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists an increasing subsequence of this length
  (∃ sub : List Int, IsIncreasingSubseqOf sub nums ∧ sub.length = result.toNat) ∧
  -- No increasing subsequence is longer
  (∀ sub : List Int, IsIncreasingSubseqOf sub nums → (sub.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestIncreasingSubsequence_spec_satisfied (nums : List Int) (h_precond : LongestIncreasingSubsequence_precond nums) :
    LongestIncreasingSubsequence_postcond nums (LongestIncreasingSubsequence nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof