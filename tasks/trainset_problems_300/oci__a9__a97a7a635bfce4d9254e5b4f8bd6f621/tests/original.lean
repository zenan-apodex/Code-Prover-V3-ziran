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
inductive FibRel : Nat → Int → Prop where
  | zero : FibRel 0 0
  | one : FibRel 1 1
  | step {k a b : Nat} {fa fb : Int} :
      FibRel a fa →
      FibRel b fb →
      a + 1 = b →
      b + 1 = k →
      FibRel k (fa + fb)
-- !benchmark @end postcond_aux


@[reducible, simp]
def Fibonacci_postcond (n : Int) (result : Int) (h_precond : Fibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  FibRel (Int.toNat n) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Fibonacci_spec_satisfied (n : Int) (h_precond : Fibonacci_precond n) :
    Fibonacci_postcond n (Fibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof