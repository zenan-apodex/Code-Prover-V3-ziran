-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def IsIntPrime (z : Int) : Prop :=
  ∃ m : Nat, z = (m : Int) ∧ Nat.Prime m
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
-- !benchmark @end postcond_aux

@[reducible, simp]
def SieveOfEratosthenes_postcond (n : Int) (result : List Int)
    (h_precond : SieveOfEratosthenes_precond n) : Prop :=
  -- !benchmark @start postcond
  (∀ z : Int, z ∈ result ↔ IsIntPrime z ∧ z ≤ n) ∧
  List.Pairwise (fun a b => a < b) result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SieveOfEratosthenes_spec_satisfied (n : Int)
    (h_precond : SieveOfEratosthenes_precond n) :
    SieveOfEratosthenes_postcond n (SieveOfEratosthenes n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof