-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PerfectSquares_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 1000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def PerfectSquares (n : Int) (h_precond : PerfectSquares_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def PerfectSquares_postcond (n : Int) (result : List Int)
    (h_precond : PerfectSquares_precond n) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a < b) result ∧
  (∀ x : Int, x ∈ result ↔ ∃ k : Int, 0 < k ∧ x = k * k ∧ x ≤ n)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem PerfectSquares_spec_satisfied (n : Int) (h_precond : PerfectSquares_precond n) :
    PerfectSquares_postcond n (PerfectSquares n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof