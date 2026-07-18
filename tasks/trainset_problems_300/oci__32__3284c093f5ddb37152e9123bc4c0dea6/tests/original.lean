-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ElementwiseSum_precond (list1 : List Int) (list2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ElementwiseSum (list1 : List Int) (list2 : List Int)
    (h_precond : ElementwiseSum_precond list1 list2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ElementwiseSum_postcond (list1 : List Int) (list2 : List Int) (result : List Int)
    (h_precond : ElementwiseSum_precond list1 list2) : Prop :=
  -- !benchmark @start postcond
  result.length = max list1.length list2.length ∧
  ∀ i : Nat, i < result.length →
    result.getD i 0 = list1.getD i 0 + list2.getD i 0
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ElementwiseSum_spec_satisfied (list1 : List Int) (list2 : List Int)
    (h_precond : ElementwiseSum_precond list1 list2) :
    ElementwiseSum_postcond list1 list2 (ElementwiseSum list1 list2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof