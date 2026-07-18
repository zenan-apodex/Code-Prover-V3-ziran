-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxArea_precond (heights : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ h ∈ heights, 0 ≤ h
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaxArea (heights : List Int) (h_precond : MaxArea_precond heights) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def containerArea (heights : List Int) (i j : Nat) : Int :=
  (Int.ofNat (j - i)) * min (heights[i]!) (heights[j]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxArea_postcond (heights : List Int) (result : Int) (h_precond : MaxArea_precond heights) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  (∀ i j : Nat, j < heights.length → i < j → containerArea heights i j ≤ result) ∧
  ((heights.length < 2 → result = 0) ∧
   (2 ≤ heights.length →
      ∃ i j : Nat,
        i < j ∧
        j < heights.length ∧
        result = containerArea heights i j))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaxArea_spec_satisfied (heights : List Int) (h_precond : MaxArea_precond heights) :
    MaxArea_postcond heights (MaxArea heights h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof