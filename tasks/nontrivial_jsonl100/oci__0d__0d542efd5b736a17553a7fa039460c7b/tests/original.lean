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
/-- `IsStrictlyIncreasing xs` means the list `xs` is strictly increasing. -/
def IsStrictlyIncreasing : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a < b ∧ IsStrictlyIncreasing (b :: rest)

/-- `IsSubsequenceOf sub lst` means `sub` can be obtained by deleting
    elements from `lst` without changing the order. -/
def IsSubsequenceOf : List Int → List Int → Prop
  | [], _ => True
  | _ :: _, [] => False
  | a :: as', b :: bs' =>
    (a = b ∧ IsSubsequenceOf as' bs') ∨ IsSubsequenceOf (a :: as') bs'
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthOfLis_postcond (nums : List Int) (result : Int) (h_precond : LengthOfLis_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists a strictly increasing subsequence of `nums` with length `result`
  (∃ sub : List Int,
    IsSubsequenceOf sub nums ∧
    IsStrictlyIncreasing sub ∧
    sub.length = result.toNat) ∧
  -- No strictly increasing subsequence of `nums` has length greater than `result`
  (∀ sub : List Int,
    IsSubsequenceOf sub nums →
    IsStrictlyIncreasing sub →
    (sub.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LengthOfLis_spec_satisfied (nums : List Int) (h_precond : LengthOfLis_precond nums) :
    LengthOfLis_postcond nums (LengthOfLis nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof