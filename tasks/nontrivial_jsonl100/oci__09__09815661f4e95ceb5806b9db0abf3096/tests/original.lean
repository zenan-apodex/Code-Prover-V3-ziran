-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def IsConnectedGraph_adj (edges : List (List Int)) (u v : Int) : Prop :=
  ∃ e ∈ edges, (e = [u, v] ∨ e = [v, u])

inductive IsConnectedGraph_reachable (edges : List (List Int)) : Int → Int → Prop where
  | refl : ∀ x, IsConnectedGraph_reachable edges x x
  | step : ∀ x y z, IsConnectedGraph_adj edges x y → IsConnectedGraph_reachable edges y z → IsConnectedGraph_reachable edges x z
-- !benchmark @end precond_aux

@[reducible, simp]
def IsConnectedGraph_precond (n : Int) (m : Int) (edges : List (List Int)) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧
  m ≥ 0 ∧
  edges.length = Int.toNat m ∧
  (∀ e ∈ edges, e.length = 2 ∧
    1 ≤ e[0]! ∧ e[0]! ≤ n ∧
    1 ≤ e[1]! ∧ e[1]! ≤ n)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsConnectedGraph (n : Int) (m : Int) (edges : List (List Int)) (h_precond : IsConnectedGraph_precond n m edges) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def IsConnectedGraph_postcond (n : Int) (m : Int) (edges : List (List Int)) (result : Bool) (h_precond : IsConnectedGraph_precond n m edges) : Prop :=
  -- !benchmark @start postcond
  result = true ↔
    (∀ u v : Int, 1 ≤ u ∧ u ≤ n → 1 ≤ v ∧ v ≤ n → IsConnectedGraph_reachable edges u v)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsConnectedGraph_spec_satisfied (n : Int) (m : Int) (edges : List (List Int)) (h_precond : IsConnectedGraph_precond n m edges) :
    IsConnectedGraph_postcond n m edges (IsConnectedGraph n m edges h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof