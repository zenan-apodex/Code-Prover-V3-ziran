-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def ShortestPathLength_precond (graph : List (Nat × List Nat)) (N : Nat) : Prop :=
  -- !benchmark @start precond
  N ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def ShortestPathLength (graph : List (Nat × List Nat)) (N : Nat) (h_precond : ShortestPathLength_precond graph N) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (Nat × List Nat)) (node : Nat) : List Nat :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A path is a list of nodes [v₀, v₁, ..., vₖ] where each consecutive pair has an edge. -/
def isPathInGraph (graph : List (Nat × List Nat)) (path : List Nat) : Prop :=
  ∀ i, i + 1 < path.length → path[i + 1]! ∈ graphNeighbors graph (path[i]!)

/-- A path from `src` to `dst` in the graph. -/
def isPathFromTo (graph : List (Nat × List Nat)) (path : List Nat) (src dst : Nat) : Prop :=
  path.length ≥ 1 ∧
  path[0]! = src ∧
  path[path.length - 1]! = dst ∧
  isPathInGraph graph path
-- !benchmark @end postcond_aux


@[reducible, simp]
def ShortestPathLength_postcond (graph : List (Nat × List Nat)) (N : Nat) (result : Int) (h_precond : ShortestPathLength_precond graph N) : Prop :=
  -- !benchmark @start postcond
  (result = -1 →
    ¬ ∃ path : List Nat, isPathFromTo graph path 1 N) ∧
  (result ≥ 0 →
    (∃ path : List Nat, isPathFromTo graph path 1 N ∧ path.length = result.toNat + 1) ∧
    (∀ path : List Nat, isPathFromTo graph path 1 N → (path.length : Int) - 1 ≥ result)) ∧
  (result = -1 ∨ result ≥ 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem ShortestPathLength_spec_satisfied (graph : List (Nat × List Nat)) (N : Nat) (h_precond : ShortestPathLength_precond graph N) :
    ShortestPathLength_postcond graph N (ShortestPathLength graph N h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof