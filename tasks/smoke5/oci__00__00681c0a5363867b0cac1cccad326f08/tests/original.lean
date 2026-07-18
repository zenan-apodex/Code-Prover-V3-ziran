-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def PrimeNumbersBelow_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def PrimeNumbersBelow (n : Int) (h_precond : PrimeNumbersBelow_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def PrimeNumbersBelow_postcond (n : Int) (result : List Int) (h_precond : PrimeNumbersBelow_precond n) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a prime less than n
  (∀ x ∈ result, x ≥ 2 ∧ x < n ∧ Nat.Prime (Int.toNat x)) ∧
  -- Every prime less than n is in result
  (∀ p : Nat, Nat.Prime p → (p : Int) < n → (p : Int) ∈ result) ∧
  -- No duplicates
  result.Nodup ∧
  -- Result is sorted in ascending order
  List.Pairwise (· < ·) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem PrimeNumbersBelow_spec_satisfied (n : Int) (h_precond : PrimeNumbersBelow_precond n) :
    PrimeNumbersBelow_postcond n (PrimeNumbersBelow n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof