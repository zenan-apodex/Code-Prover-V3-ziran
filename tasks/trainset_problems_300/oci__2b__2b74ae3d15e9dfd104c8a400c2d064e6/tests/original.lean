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


def Fibonacci (n : Int) (h_precond : Fibonacci_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def SatisfiesFibAt (m : Nat) (r : Int) : Prop :=
  ∃ f : Nat → Int,
    f 0 = 0 ∧
    f 1 = 1 ∧
    (∀ i : Nat, 2 ≤ i → i ≤ m → f i = f (i - 1) + f (i - 2)) ∧
    f m = r
-- !benchmark @end postcond_aux


@[reducible, simp]
def Fibonacci_postcond (n : Int) (result : Int) (h_precond : Fibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  (n ≤ 0 → result = 0) ∧
  (0 < n → SatisfiesFibAt (Int.toNat n) result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Fibonacci_spec_satisfied (n : Int) (h_precond : Fibonacci_precond n) :
    Fibonacci_postcond n (Fibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof