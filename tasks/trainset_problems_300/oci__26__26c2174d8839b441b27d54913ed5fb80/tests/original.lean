-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FibonacciSequence_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FibonacciSequence (n : Int) (h_precond : FibonacciSequence_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FibonacciSequence_postcond (n : Int) (result : List Int)
    (h_precond : FibonacciSequence_precond n) : Prop :=
  -- !benchmark @start postcond
  result.length = Int.toNat n ∧
  ∀ i : Nat, i < result.length → result[i]! = Int.ofNat (Nat.fib i)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FibonacciSequence_spec_satisfied (n : Int)
    (h_precond : FibonacciSequence_precond n) :
    FibonacciSequence_postcond n (FibonacciSequence n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof