-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SquareIntegers_precond (int_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SquareIntegers (int_list : List Int) (h_precond : SquareIntegers_precond int_list) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SquareIntegers_postcond (int_list : List Int) (result : List Int)
    (h_precond : SquareIntegers_precond int_list) : Prop :=
  -- !benchmark @start postcond
  result.length = int_list.length ∧
  ∀ i : Nat, i < int_list.length → result[i]! = int_list[i]! * int_list[i]!
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SquareIntegers_spec_satisfied (int_list : List Int)
    (h_precond : SquareIntegers_precond int_list) :
    SquareIntegers_postcond int_list (SquareIntegers int_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof