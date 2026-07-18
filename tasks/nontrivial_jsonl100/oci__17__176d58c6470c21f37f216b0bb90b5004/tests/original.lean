-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def SieveOfEratosthenes_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def SieveOfEratosthenes (n : Int) (h_precond : SieveOfEratosthenes_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPrimeInt (p : Int) : Prop :=
  p ≥ 2 ∧ ∀ d : Int, 2 ≤ d → d < p → ¬(p % d = 0)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SieveOfEratosthenes_postcond (n : Int) (result : List Int) (h_precond : SieveOfEratosthenes_precond n) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a prime ≤ n
  (∀ p, p ∈ result → isPrimeInt p ∧ 2 ≤ p ∧ p ≤ n) ∧
  -- Every prime ≤ n is in result
  (∀ p : Int, 2 ≤ p → p ≤ n → isPrimeInt p → p ∈ result) ∧
  -- No duplicates
  result.Nodup ∧
  -- Result is sorted in ascending order
  List.Pairwise (· < ·) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem SieveOfEratosthenes_spec_satisfied (n : Int) (h_precond : SieveOfEratosthenes_precond n) :
    SieveOfEratosthenes_postcond n (SieveOfEratosthenes n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof