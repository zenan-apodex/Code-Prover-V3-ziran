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
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def Fibonacci (n : Int) (h_precond : Fibonacci_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def Fibonacci_postcond (n : Int) (result : List Int)
    (h_precond : Fibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  result.length = Int.toNat n ∧
  (0 < result.length → result[0]! = 0) ∧
  (1 < result.length → result[1]! = 1) ∧
  (∀ i : Nat, i + 2 < result.length →
    result[i + 2]! = result[i + 1]! + result[i]!)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem Fibonacci_spec_satisfied (n : Int)
    (h_precond : Fibonacci_precond n) :
    Fibonacci_postcond n (Fibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof