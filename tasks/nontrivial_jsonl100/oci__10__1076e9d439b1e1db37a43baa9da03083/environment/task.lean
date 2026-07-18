-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsCyclic_precond (graph : List (List Int)) : Prop :=
  -- !benchmark @start precond
  let V := graph.length
  V ≥ 1 ∧
  -- Square matrix
  (∀ row ∈ graph, row.length = V) ∧
  -- Only 0s and 1s
  (∀ row ∈ graph, ∀ x ∈ row, x = 0 ∨ x = 1) ∧
  -- No self-loops
  (∀ i : Nat, i < V → (graph[i]!)[i]! = 0)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsCyclic_fun (graph : List (List Int)) (h_precond : IsCyclic_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- There is a directed edge from u to v in the adjacency matrix. -/
def hasEdge' (graph : List (List Int)) (u v : Nat) : Prop :=
  u < graph.length ∧ v < graph.length ∧ (graph[u]!)[v]! = 1

/-- A directed cycle exists: a non-empty list of distinct vertices forming a closed walk. -/
def hasCycle' (graph : List (List Int)) : Prop :=
  ∃ (cycle : List Nat),
    cycle.length ≥ 1 ∧
    -- All vertices in range
    (∀ v ∈ cycle, v < graph.length) ∧
    -- All vertices distinct (simple cycle)
    cycle.Nodup ∧
    -- Each consecutive pair has an edge
    (∀ i : Nat, i < cycle.length → hasEdge' graph (cycle[i]!) (cycle[(i + 1) % cycle.length]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsCyclic_postcond (graph : List (List Int)) (result : Bool) (h_precond : IsCyclic_precond graph) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ hasCycle' graph)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsCyclic_spec_satisfied (graph : List (List Int)) (h_precond : IsCyclic_precond graph) :
    IsCyclic_postcond graph (IsCyclic_fun graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof