-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ExtractEvenNumbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ExtractEvenNumbers (numbers : List Int) (h_precond : ExtractEvenNumbers_precond numbers) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive ExtractEvenNumbersRel : List Int → List Int → Prop
| nil : ExtractEvenNumbersRel [] []
| keep {x : Int} {xs ys : List Int} :
    x % 2 = 0 →
    ExtractEvenNumbersRel xs ys →
    ExtractEvenNumbersRel (x :: xs) (x :: ys)
| skip {x : Int} {xs ys : List Int} :
    x % 2 ≠ 0 →
    ExtractEvenNumbersRel xs ys →
    ExtractEvenNumbersRel (x :: xs) ys
-- !benchmark @end postcond_aux


@[reducible, simp]
def ExtractEvenNumbers_postcond (numbers : List Int) (result : List Int)
    (h_precond : ExtractEvenNumbers_precond numbers) : Prop :=
  -- !benchmark @start postcond
  ExtractEvenNumbersRel numbers result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ExtractEvenNumbers_spec_satisfied (numbers : List Int)
    (h_precond : ExtractEvenNumbers_precond numbers) :
    ExtractEvenNumbers_postcond numbers (ExtractEvenNumbers numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof