-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def NumberFrequency_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def NumberFrequency (numbers : List Int) (h_precond : NumberFrequency_precond numbers) : List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def NumberFrequency_postcond (numbers : List Int) (result : List (Int × Int))
    (h_precond : NumberFrequency_precond numbers) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, p.2 = Int.ofNat ((numbers.filter (· = p.1)).length)) ∧
  (∀ n ∈ numbers, ∃ p ∈ result, p.1 = n) ∧
  (∀ p ∈ result, p.1 ∈ numbers) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem NumberFrequency_spec_satisfied (numbers : List Int)
    (h_precond : NumberFrequency_precond numbers) :
    NumberFrequency_postcond numbers (NumberFrequency numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof