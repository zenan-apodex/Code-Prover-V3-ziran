-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def LengthsOfStrings_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def LengthsOfStrings (strings : List String) (h_precond : LengthsOfStrings_precond strings) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def LengthsOfStrings_postcond (strings : List String) (result : List Int)
    (h_precond : LengthsOfStrings_precond strings) : Prop :=
  -- !benchmark @start postcond
  result.length = strings.length ∧
  ∀ i : Nat, i < strings.length →
    result[i]! = Int.ofNat (strings[i]!.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LengthsOfStrings_spec_satisfied (strings : List String)
    (h_precond : LengthsOfStrings_precond strings) :
    LengthsOfStrings_postcond strings (LengthsOfStrings strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof