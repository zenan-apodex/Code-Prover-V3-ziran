-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive SumDigitsNat : Nat → Nat → Prop
| zero : SumDigitsNat 0 0
| step (n s : Nat) :
    n > 0 →
    SumDigitsNat (n / 10) s →
    SumDigitsNat n (n % 10 + s)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SumOfDigitsRecursive_precond (number : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ number
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SumOfDigitsRecursive (number : Int) (h_precond : SumOfDigitsRecursive_precond number) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SumOfDigitsRecursive_postcond (number : Int) (result : Int)
    (h_precond : SumOfDigitsRecursive_precond number) : Prop :=
  -- !benchmark @start postcond
  ∃ s : Nat,
    SumDigitsNat number.natAbs s ∧
    result = Int.ofNat s
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SumOfDigitsRecursive_spec_satisfied (number : Int)
    (h_precond : SumOfDigitsRecursive_precond number) :
    SumOfDigitsRecursive_postcond number (SumOfDigitsRecursive number h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof