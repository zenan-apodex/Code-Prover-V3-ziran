-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PrimeFactors_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ n
  -- !benchmark @end precond

-- !benchmark @start code_aux
def IntPrime (z : Int) : Prop :=
  1 < z ∧ Nat.Prime z.natAbs
-- !benchmark @end code_aux

def PrimeFactors (n : Int) (h_precond : PrimeFactors_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def PrimeFactors_postcond (n : Int) (result : List Int)
    (h_precond : PrimeFactors_precond n) : Prop :=
  -- !benchmark @start postcond
  result.prod = n ∧
  (∀ x ∈ result, IntPrime x) ∧
  List.Pairwise (fun a b => a ≤ b) result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem PrimeFactors_spec_satisfied (n : Int)
    (h_precond : PrimeFactors_precond n) :
    PrimeFactors_postcond n (PrimeFactors n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof