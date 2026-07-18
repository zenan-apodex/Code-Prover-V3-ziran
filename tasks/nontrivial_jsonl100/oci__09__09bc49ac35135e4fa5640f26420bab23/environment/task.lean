-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
/-- Look up neighbors of a node in the adjacency list. -/
def adjLookup (graph : List (Nat × List Nat)) (node : Nat) : List Nat :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A path is a non-empty list of nodes where each consecutive pair (u, v) has v in adj(u). -/
def isPathInGraph (graph : List (Nat × List Nat)) (path : List Nat) : Prop :=
  path.length ≥ 1 ∧
  ∀ i, i + 1 < path.length → path[i + 1]! ∈ adjLookup graph path[i]!

/-- The number of edges in a path (= length of node list - 1). -/
def pathEdgeCount (path : List Nat) : Nat :=
  path.length - 1
-- !benchmark @end precond_aux

@[reducible, simp]
def LongestPathDag_precond (graph : List (Nat × List Nat)) : Prop :=
  -- !benchmark @start precond
  -- Keys are pairwise distinct (it's a valid adjacency list / dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestPathDag (graph : List (Nat × List Nat)) (h_precond : LongestPathDag_precond graph) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestPathDag_postcond (graph : List (Nat × List Nat)) (result : Nat) (h_precond : LongestPathDag_precond graph) : Prop :=
  -- !benchmark @start postcond
  -- There exists a path achieving `result` edges
  (∃ path : List Nat, isPathInGraph graph path ∧ pathEdgeCount path = result) ∧
  -- No path has more than `result` edges
  (∀ path : List Nat, isPathInGraph graph path → pathEdgeCount path ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestPathDag_spec_satisfied (graph : List (Nat × List Nat)) (h_precond : LongestPathDag_precond graph) :
    LongestPathDag_postcond graph (LongestPathDag graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof