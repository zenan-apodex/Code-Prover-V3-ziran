-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Factorial_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 20
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def Factorial (n : Int) (h_precond : Factorial_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
inductive FactorialRel : Nat → Nat → Prop where
  | zero : FactorialRel 0 1
  | succ {n value} : FactorialRel n value → FactorialRel (n + 1) ((n + 1) * value)
-- !benchmark @end postcond_aux

@[reducible, simp]
def Factorial_postcond (n : Int) (result : Int)
    (h_precond : Factorial_precond n) : Prop :=
  -- !benchmark @start postcond
  0 ≤ result ∧ FactorialRel n.toNat result.toNat
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem Factorial_spec_satisfied (n : Int)
    (h_precond : Factorial_precond n) :
    Factorial_postcond n (Factorial n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof