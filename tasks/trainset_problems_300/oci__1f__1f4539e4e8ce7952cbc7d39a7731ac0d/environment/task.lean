-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FilterEvenNumbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  numbers.length ≤ 1000 ∧
  (∀ num ∈ numbers, (-1000 : Int) ≤ num ∧ num ≤ 1000)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FilterEvenNumbers (numbers : List Int) (h_precond : FilterEvenNumbers_precond numbers) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def FilterEvenNumbers_IsEven (x : Int) : Prop :=
  x % 2 = 0

inductive FilterEvenNumbersRel : List Int → List Int → Prop
| nil : FilterEvenNumbersRel [] []
| keep {x : Int} {xs ys : List Int} :
    FilterEvenNumbers_IsEven x →
    FilterEvenNumbersRel xs ys →
    FilterEvenNumbersRel (x :: xs) (x :: ys)
| drop {x : Int} {xs ys : List Int} :
    ¬ FilterEvenNumbers_IsEven x →
    FilterEvenNumbersRel xs ys →
    FilterEvenNumbersRel (x :: xs) ys
-- !benchmark @end postcond_aux


@[reducible, simp]
def FilterEvenNumbers_postcond (numbers : List Int) (result : List Int)
    (h_precond : FilterEvenNumbers_precond numbers) : Prop :=
  -- !benchmark @start postcond
  FilterEvenNumbersRel numbers result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FilterEvenNumbers_spec_satisfied (numbers : List Int)
    (h_precond : FilterEvenNumbers_precond numbers) :
    FilterEvenNumbers_postcond numbers (FilterEvenNumbers numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof