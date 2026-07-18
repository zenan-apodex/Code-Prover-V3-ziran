-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsBipartite_precond (graph : List (Int × List Int)) : Prop :=
  -- !benchmark @start precond
  -- Keys are unique
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsBipartite (graph : List (Int × List Int)) (h_precond : IsBipartite_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Get the set of all vertices (keys) in the graph -/
def graphVertices (graph : List (Int × List Int)) : List Int :=
  graph.map Prod.fst

/-- Look up neighbors of a vertex in the adjacency list -/
def graphNeighbors (graph : List (Int × List Int)) (v : Int) : List Int :=
  match graph.find? (fun p => p.1 == v) with
  | some p => p.2
  | none => []

/-- A graph is bipartite iff there exists a 2-coloring (function from vertices to Bool)
    such that for every edge (u, v), the colors of u and v differ. -/
def isBipartiteProp (graph : List (Int × List Int)) : Prop :=
  ∃ color : Int → Bool,
    ∀ p ∈ graph, ∀ w ∈ p.2, color p.1 ≠ color w
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsBipartite_postcond (graph : List (Int × List Int)) (result : Bool)
    (h_precond : IsBipartite_precond graph) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ isBipartiteProp graph
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsBipartite_spec_satisfied (graph : List (Int × List Int))
    (h_precond : IsBipartite_precond graph) :
    IsBipartite_postcond graph (IsBipartite graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof