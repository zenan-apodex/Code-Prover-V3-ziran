-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Fibonacci_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 50
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def Fibonacci (n : Int) (h_precond : Fibonacci_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive FibonacciValue : Nat → Int → Prop
| zero : FibonacciValue 0 0
| one : FibonacciValue 1 1
| step {k : Nat} {a b : Int} :
    FibonacciValue k a →
    FibonacciValue (k + 1) b →
    FibonacciValue (k + 2) (a + b)
-- !benchmark @end postcond_aux


@[reducible, simp]
def Fibonacci_postcond (n : Int) (result : Int) (h_precond : Fibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  FibonacciValue n.toNat result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Fibonacci_spec_satisfied (n : Int) (h_precond : Fibonacci_precond n) :
    Fibonacci_postcond n (Fibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof