-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SquaresOfDivisibleByThree_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SquaresOfDivisibleByThree (numbers : List Int)
    (h_precond : SquaresOfDivisibleByThree_precond numbers) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive SquaresOfDivisibleByThreeRel : List Int → List Int → Prop where
  | nil :
      SquaresOfDivisibleByThreeRel [] []
  | skip (x : Int) (xs : List Int) (ys : List Int) :
      x % 3 ≠ 0 →
      SquaresOfDivisibleByThreeRel xs ys →
      SquaresOfDivisibleByThreeRel (x :: xs) ys
  | take (x : Int) (xs : List Int) (ys : List Int) :
      x % 3 = 0 →
      SquaresOfDivisibleByThreeRel xs ys →
      SquaresOfDivisibleByThreeRel (x :: xs) ((x * x) :: ys)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SquaresOfDivisibleByThree_postcond (numbers : List Int) (result : List Int)
    (h_precond : SquaresOfDivisibleByThree_precond numbers) : Prop :=
  -- !benchmark @start postcond
  SquaresOfDivisibleByThreeRel numbers result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SquaresOfDivisibleByThree_spec_satisfied (numbers : List Int)
    (h_precond : SquaresOfDivisibleByThree_precond numbers) :
    SquaresOfDivisibleByThree_postcond numbers
      (SquaresOfDivisibleByThree numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof