-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ThreeSum_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ThreeSum (nums : List Int) (h_precond : ThreeSum_precond nums) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def countInt (x : Int) (xs : List Int) : Nat :=
  (xs.filter (fun y => y = x)).length
-- !benchmark @end postcond_aux


@[reducible, simp]
def ThreeSum_postcond (nums : List Int) (result : List (List Int)) (h_precond : ThreeSum_precond nums) : Prop :=
  -- !benchmark @start postcond
  (∀ t ∈ result,
    ∃ a b c : Int,
      t = [a, b, c] ∧
      a ≤ b ∧
      b ≤ c ∧
      a + b + c = 0 ∧
      (∀ x : Int, countInt x [a, b, c] ≤ countInt x nums)) ∧
  (∀ a b c : Int,
      a ≤ b →
      b ≤ c →
      a + b + c = 0 →
      (∀ x : Int, countInt x [a, b, c] ≤ countInt x nums) →
      [a, b, c] ∈ result) ∧
  List.Pairwise (fun t₁ t₂ => t₁ ≠ t₂) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ThreeSum_spec_satisfied (nums : List Int) (h_precond : ThreeSum_precond nums) :
    ThreeSum_postcond nums (ThreeSum nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof