-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PrintBinary_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ num ∧ num < 2 ^ (32 : Nat)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def PrintBinary (num : Int) (h_precond : PrintBinary_precond num) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def bitCharOf (b : Bool) : Char :=
  if b then '1' else '0'
-- !benchmark @end postcond_aux


@[reducible, simp]
def PrintBinary_postcond (num : Int) (result : String) (h_precond : PrintBinary_precond num) : Prop :=
  -- !benchmark @start postcond
  result.length = 32 ∧
  ∀ i : Nat, i < 32 →
    result.toList[i]! =
      bitCharOf (((num / (2 ^ (31 - i : Nat) : Int)) % 2) = 1)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem PrintBinary_spec_satisfied (num : Int) (h_precond : PrintBinary_precond num) :
    PrintBinary_postcond num (PrintBinary num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof