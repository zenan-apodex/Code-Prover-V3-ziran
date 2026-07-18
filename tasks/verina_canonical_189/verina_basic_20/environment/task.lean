-- !benchmark @start import type=solution
import Mathlib
import Std.Data.HashSet
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def uniqueProduct_precond (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def uniqueProduct (arr : Array Int) (h_precond : uniqueProduct_precond (arr)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def uniqueProduct_postcond (arr : Array Int) (result: Int) (h_precond : uniqueProduct_precond (arr)) :=
  -- !benchmark @start postcond
  result - (arr.toList.eraseDups.foldl (· * ·) 1) = 0 ∧
  (arr.toList.eraseDups.foldl (· * ·) 1) - result = 0
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem uniqueProduct_spec_satisfied (arr: Array Int) (h_precond : uniqueProduct_precond (arr)) :
    uniqueProduct_postcond (arr) (uniqueProduct (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
