-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LengthOfLis_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LengthOfLis (nums : List Int) (h_precond : LengthOfLis_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseq sub l` means `sub` is a subsequence of `l` (preserving order, not necessarily contiguous). -/
def IsSubseq : List Int → List Int → Prop
  | [], _ => True
  | _ :: _, [] => False
  | a :: as, b :: bs =>
    if a = b then IsSubseq as bs
    else IsSubseq (a :: as) bs

/-- A list is strictly increasing. -/
def StrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ StrictlyIncreasing (b :: rest)

/-- `IsIncreasingSubseq sub l` means `sub` is a strictly increasing subsequence of `l`. -/
def IsIncreasingSubseq (sub l : List Int) : Prop :=
  IsSubseq sub l ∧ StrictlyIncreasing sub
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Int) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists an increasing subsequence of this length
  (∃ sub : List Int, IsIncreasingSubseq sub nums ∧ sub.length = result.toNat) ∧
  -- No increasing subsequence is longer
  (∀ sub : List Int, IsIncreasingSubseq sub nums → sub.length ≤ result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof