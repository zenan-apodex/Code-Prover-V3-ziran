-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ProductExceptSelf_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ProductExceptSelf (nums : List Int) (h_precond : ProductExceptSelf_precond nums) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def ProductExceptSelf_postcond (nums : List Int) (result : List Int)
    (h_precond : ProductExceptSelf_precond nums) : Prop :=
  -- !benchmark @start postcond
  result.length = nums.length ∧
  ∀ i : Nat, i < nums.length →
    result[i]! = (nums.take i).prod * (nums.drop (i + 1)).prod
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ProductExceptSelf_spec_satisfied (nums : List Int)
    (h_precond : ProductExceptSelf_precond nums) :
    ProductExceptSelf_postcond nums (ProductExceptSelf nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof