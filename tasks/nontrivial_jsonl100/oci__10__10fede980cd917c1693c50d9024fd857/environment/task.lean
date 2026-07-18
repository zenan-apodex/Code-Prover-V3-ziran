-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- Check that graph is a valid n×n adjacency matrix with 0/1 entries
def isConnected_validGraph (graph : List (List Int)) : Prop :=
  let n := graph.length
  ∀ i, i < n → (graph[i]!).length = n ∧
    ∀ j, j < n → ((graph[i]!)[j]! = 0 ∨ (graph[i]!)[j]! = 1)
-- !benchmark @end precond_aux

@[reducible, simp]
def isConnected_precond (graph : List (List Int)) : Prop :=
  -- !benchmark @start precond
  isConnected_validGraph graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def isConnected (graph : List (List Int)) (h_precond : isConnected_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- There is an edge between nodes i and j in the graph -/
def isConnected_hasEdge (graph : List (List Int)) (i j : Nat) : Prop :=
  i < graph.length ∧ j < graph.length ∧ (graph[i]!)[j]! = 1

/-- There is a path from node i to node j: defined as the reflexive-transitive closure of the edge relation -/
inductive isConnected_Reachable (graph : List (List Int)) : Nat → Nat → Prop where
  | refl (i : Nat) (h : i < graph.length) : isConnected_Reachable graph i i
  | step (i j k : Nat) : isConnected_hasEdge graph i j → isConnected_Reachable graph j k → isConnected_Reachable graph i k

def isConnected_graphConnected (graph : List (List Int)) : Prop :=
  let n := graph.length
  n = 0 ∨ (∀ i j, i < n → j < n → isConnected_Reachable graph i j)
-- !benchmark @end postcond_aux


@[reducible, simp]
def isConnected_postcond (graph : List (List Int)) (result : Bool) (h_precond : isConnected_precond graph) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ isConnected_graphConnected graph)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem isConnected_spec_satisfied (graph : List (List Int)) (h_precond : isConnected_precond graph) :
    isConnected_postcond graph (isConnected graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof