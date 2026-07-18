-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsBipartite_precond (graph : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  -- All neighbor indices are valid (< graph.length), and the graph is undirected (symmetric)
  (∀ i, i < graph.length →
    ∀ j, j ∈ graph[i]! → j < graph.length) ∧
  (∀ i, i < graph.length →
    ∀ j, j ∈ graph[i]! → i ∈ graph[j]!) ∧
  -- No self-loops
  (∀ i, i < graph.length → i ∉ graph[i]!)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsBipartite (graph : List (List Nat)) (h_precond : IsBipartite_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isBipartiteGraph (graph : List (List Nat)) : Prop :=
  ∃ (color : Nat → Bool),
    ∀ i, i < graph.length →
      ∀ j, j ∈ graph[i]! →
        color i ≠ color j
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsBipartite_postcond (graph : List (List Nat)) (result : Bool) (h_precond : IsBipartite_precond graph) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ isBipartiteGraph graph)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsBipartite_spec_satisfied (graph : List (List Nat)) (h_precond : IsBipartite_precond graph) :
    IsBipartite_postcond graph (IsBipartite graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof