-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxProfit_precond (prices : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ p ∈ prices, 0 ≤ p
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaxProfit (prices : List Int) (h_precond : MaxProfit_precond prices) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxProfit_postcond (prices : List Int) (result : Int)
    (h_precond : MaxProfit_precond prices) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  (∀ i j : Nat, i < j → j < prices.length → prices[j]! - prices[i]! ≤ result) ∧
  (result = 0 ∨ ∃ i j : Nat, i < j ∧ j < prices.length ∧ result = prices[j]! - prices[i]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaxProfit_spec_satisfied (prices : List Int) (h_precond : MaxProfit_precond prices) :
    MaxProfit_postcond prices (MaxProfit prices h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof