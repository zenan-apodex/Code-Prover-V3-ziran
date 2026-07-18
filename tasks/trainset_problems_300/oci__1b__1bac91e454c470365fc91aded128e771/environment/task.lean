-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateFibonacci_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def GenerateFibonacci (n : Int) (h_precond : GenerateFibonacci_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def FibValue : Nat → Int
  | 0 => 0
  | 1 => 1
  | k + 2 => FibValue (k + 1) + FibValue k
-- !benchmark @end postcond_aux


@[reducible, simp]
def GenerateFibonacci_postcond (n : Int) (result : List Int)
    (h_precond : GenerateFibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  result.length = Int.toNat n ∧
  ∀ i : Nat, i < result.length → result[i]! = FibValue i
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem GenerateFibonacci_spec_satisfied (n : Int) (h_precond : GenerateFibonacci_precond n) :
    GenerateFibonacci_postcond n (GenerateFibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof