-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMissingNumber_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≠ b) nums ∧
  ∀ x ∈ nums, 0 ≤ x ∧ x ≤ Int.ofNat nums.length
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindMissingNumber (nums : List Int) (h_precond : FindMissingNumber_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindMissingNumber_postcond (nums : List Int) (result : Int)
    (h_precond : FindMissingNumber_precond nums) : Prop :=
  -- !benchmark @start postcond
  0 ≤ result ∧
  result ≤ Int.ofNat nums.length ∧
  result ∉ nums ∧
  (∀ x : Int, 0 ≤ x → x ≤ Int.ofNat nums.length → x = result ∨ x ∈ nums)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindMissingNumber_spec_satisfied (nums : List Int)
    (h_precond : FindMissingNumber_precond nums) :
    FindMissingNumber_postcond nums (FindMissingNumber nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof