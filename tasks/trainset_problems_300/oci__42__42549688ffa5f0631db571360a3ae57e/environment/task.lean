-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def UniqueCombinations_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
def IsUniqueCombinationOf (nums ys : List Int) : Prop :=
  List.Pairwise (fun a b => a ≤ b) ys ∧
  ∀ z : Int, ys.count z ≤ nums.count z
-- !benchmark @end code_aux

def UniqueCombinations (nums : List Int) (h_precond : UniqueCombinations_precond nums) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def UniqueCombinations_postcond (nums : List Int) (result : List (List Int))
    (h_precond : UniqueCombinations_precond nums) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
  ∀ ys : List Int, ys ∈ result ↔ IsUniqueCombinationOf nums ys
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem UniqueCombinations_spec_satisfied (nums : List Int)
    (h_precond : UniqueCombinations_precond nums) :
    UniqueCombinations_postcond nums (UniqueCombinations nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof