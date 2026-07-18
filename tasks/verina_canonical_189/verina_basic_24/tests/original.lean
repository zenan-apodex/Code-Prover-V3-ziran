-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def isEven (n : Int) : Bool :=
  n % 2 == 0

def isOdd (n : Int) : Bool :=
  n % 2 != 0
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def firstEvenOddDifference_precond (a : Array Int) : Prop :=
  -- !benchmark @start precond
  a.size > 1 ∧
  (∃ x ∈ a, isEven x) ∧
  (∃ x ∈ a, isOdd x)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def firstEvenOddDifference (a : Array Int) (h_precond : firstEvenOddDifference_precond (a)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def firstEvenOddDifference_postcond (a : Array Int) (result: Int) (h_precond : firstEvenOddDifference_precond (a)) :=
  -- !benchmark @start postcond
  ∃ i j, i < a.size ∧ j < a.size ∧ isEven (a[i]!) ∧ isOdd (a[j]!) ∧
    result = a[i]! - a[j]! ∧
    (∀ k, k < i → isOdd (a[k]!)) ∧ (∀ k, k < j → isEven (a[k]!))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem firstEvenOddDifference_spec_satisfied (a: Array Int) (h_precond : firstEvenOddDifference_precond (a)) :
    firstEvenOddDifference_postcond (a) (firstEvenOddDifference (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
