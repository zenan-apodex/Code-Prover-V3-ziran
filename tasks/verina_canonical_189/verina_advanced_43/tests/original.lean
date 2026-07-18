-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def maxStrength_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums ≠ []
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def maxStrength (nums : List Int) (h_precond : maxStrength_precond (nums)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def maxStrength_postcond (nums : List Int) (result: Int) (h_precond : maxStrength_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let sublists := nums.sublists.filter (· ≠ [])
  let products := sublists.map (List.foldl (· * ·) 1)
  products.contains result ∧ products.all (· ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem maxStrength_spec_satisfied (nums: List Int) (h_precond : maxStrength_precond (nums)) :
    maxStrength_postcond (nums) (maxStrength (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


