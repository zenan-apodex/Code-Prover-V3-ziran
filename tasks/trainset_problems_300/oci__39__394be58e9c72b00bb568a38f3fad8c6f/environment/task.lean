-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateSubsets_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums.Nodup
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def GenerateSubsets (nums : List Int) (h_precond : GenerateSubsets_precond nums) :
    List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def GenerateSubsets_postcond (nums : List Int) (result : List (List Int))
    (h_precond : GenerateSubsets_precond nums) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
    ∀ ys : List Int, ys ∈ result ↔ List.Sublist ys nums
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem GenerateSubsets_spec_satisfied (nums : List Int)
    (h_precond : GenerateSubsets_precond nums) :
    GenerateSubsets_postcond nums (GenerateSubsets nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof