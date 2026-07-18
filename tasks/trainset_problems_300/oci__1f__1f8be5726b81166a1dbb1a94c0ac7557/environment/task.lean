-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PrimeFactors_precond (n : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ x ∈ n, 0 ≤ x
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def PrimeFactors (n : List Int) (h_precond : PrimeFactors_precond n) : List (List (Int × Nat)) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def factorizationValue (fs : List (Int × Nat)) : Nat :=
  (fs.map fun p => (Int.toNat p.1) ^ p.2).prod

def ValidPrimeFactorization (x : Int) (fs : List (Int × Nat)) : Prop :=
  if Int.toNat x ≤ 1 then
    fs = []
  else
    factorizationValue fs = Int.toNat x ∧
    List.Pairwise (fun a b => a.1 < b.1) fs ∧
    (∀ p ∈ fs, Nat.Prime (Int.toNat p.1) ∧ p.2 > 0)
-- !benchmark @end postcond_aux


@[reducible, simp]
def PrimeFactors_postcond (n : List Int) (result : List (List (Int × Nat)))
    (h_precond : PrimeFactors_precond n) : Prop :=
  -- !benchmark @start postcond
  result.length = n.length ∧
  ∀ i : Nat, i < n.length → ValidPrimeFactorization (n[i]!) (result[i]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem PrimeFactors_spec_satisfied (n : List Int) (h_precond : PrimeFactors_precond n) :
    PrimeFactors_postcond n (PrimeFactors n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof