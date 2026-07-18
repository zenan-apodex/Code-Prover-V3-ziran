-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPrime_precond (start : Int) (end_ : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ start ∧ start ≤ end_ ∧ end_ ≤ 1000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPrime (start : Int) (end_ : Int) (h_precond : IsPrime_precond start end_) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def PrimeInt (n : Int) : Prop :=
  2 ≤ n ∧ ∀ d : Int, 2 ≤ d → d < n → ¬ d ∣ n
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPrime_postcond (start : Int) (end_ : Int) (result : List Int)
    (h_precond : IsPrime_precond start end_) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a < b) result ∧
  ∀ x : Int, x ∈ result ↔ start ≤ x ∧ x ≤ end_ ∧ PrimeInt x
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPrime_spec_satisfied (start : Int) (end_ : Int)
    (h_precond : IsPrime_precond start end_) :
    IsPrime_postcond start end_ (IsPrime start end_ h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof