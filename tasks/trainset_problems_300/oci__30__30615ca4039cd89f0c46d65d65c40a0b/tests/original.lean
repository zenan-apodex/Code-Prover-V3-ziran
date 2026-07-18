-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxRectangleArea_precond (heights : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ h ∈ heights, 0 ≤ h
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaxRectangleArea (heights : List Int) (h_precond : MaxRectangleArea_precond heights) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def containerArea (heights : List Int) (i j : Nat) : Int :=
  Int.ofNat (j - i) * min (heights[i]!) (heights[j]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxRectangleArea_postcond (heights : List Int) (result : Int)
    (h_precond : MaxRectangleArea_precond heights) : Prop :=
  -- !benchmark @start postcond
  if h : heights.length < 2 then
    result = 0
  else
    0 ≤ result ∧
    (∃ i j : Nat, i < j ∧ j < heights.length ∧ result = containerArea heights i j) ∧
    (∀ i j : Nat, i < j → j < heights.length → containerArea heights i j ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaxRectangleArea_spec_satisfied (heights : List Int)
    (h_precond : MaxRectangleArea_precond heights) :
    MaxRectangleArea_postcond heights (MaxRectangleArea heights h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof