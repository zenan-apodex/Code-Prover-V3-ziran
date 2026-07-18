-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsFibonacciNumber_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  n ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsFibonacciNumber (n : Int) (h_precond : IsFibonacciNumber_precond n) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def fib : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

def isFib (n : Nat) : Prop :=
  ∃ k : Nat, fib k = n
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsFibonacciNumber_postcond (n : Int) (result : Bool) (h_precond : IsFibonacciNumber_precond n) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ isFib (Int.toNat n))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsFibonacciNumber_spec_satisfied (n : Int) (h_precond : IsFibonacciNumber_precond n) :
    IsFibonacciNumber_postcond n (IsFibonacciNumber n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof