-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def SieveOfEratosthenes_precond (N : Int) : Prop :=
  -- !benchmark @start precond
  N ≥ 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def SieveOfEratosthenes (N : Int) (h_precond : SieveOfEratosthenes_precond N) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPrime (n : Nat) : Prop :=
  n ≥ 2 ∧ ∀ d : Nat, d ≥ 2 → d < n → n % d ≠ 0
-- !benchmark @end postcond_aux


@[reducible, simp]
def SieveOfEratosthenes_postcond (N : Int) (result : List Int) (h_precond : SieveOfEratosthenes_precond N) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a prime ≤ N
  (∀ p ∈ result, p ≥ 2 ∧ p ≤ N ∧ isPrime (Int.toNat p)) ∧
  -- Every prime ≤ N is in result
  (∀ k : Nat, k ≤ Int.toNat N → isPrime k → (↑k : Int) ∈ result) ∧
  -- Result is sorted in ascending order
  List.Pairwise (· < ·) result ∧
  -- No duplicates (implied by strict sorting, but stated for clarity)
  result.Nodup
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem SieveOfEratosthenes_spec_satisfied (N : Int) (h_precond : SieveOfEratosthenes_precond N) :
    SieveOfEratosthenes_postcond N (SieveOfEratosthenes N h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof