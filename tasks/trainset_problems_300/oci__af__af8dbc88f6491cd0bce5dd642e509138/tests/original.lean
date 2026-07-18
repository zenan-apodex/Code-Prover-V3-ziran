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
  n ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def Fibonacci (n : Int) (h_precond : Fibonacci_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive FibValue : Nat → Int → Prop where
  | zero : FibValue 0 0
  | one : FibValue 1 1
  | succ_succ {k a b : Nat} :
      FibValue k a →
      FibValue (k + 1) b →
      FibValue (k + 2) (a + b)
-- !benchmark @end postcond_aux


@[reducible, simp]
def Fibonacci_postcond (n : Int) (result : Int) (h_precond : Fibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  FibValue (Int.toNat n) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Fibonacci_spec_satisfied (n : Int) (h_precond : Fibonacci_precond n) :
    Fibonacci_postcond n (Fibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof