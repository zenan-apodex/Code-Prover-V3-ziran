-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def BfsShortestPath_precond (graph : List (String × List String)) (start : String) (target : String) : Prop :=
  -- !benchmark @start precond
  -- Keys are unique (graph is a valid dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def BfsShortestPath (graph : List (String × List String)) (start : String) (target : String) (h_precond : BfsShortestPath_precond graph start target) : Option (List String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (String × List String)) (node : String) : List String :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A path is valid in the graph: consecutive nodes are connected via adjacency. -/
def isValidPath (graph : List (String × List String)) (path : List String) : Prop :=
  path.length ≥ 1 ∧
  ∀ i, i + 1 < path.length → path[i + 1]! ∈ graphNeighbors graph (path[i]!)

/-- A path goes from `start` to `target`. -/
def isPathFromTo (path : List String) (start target : String) : Prop :=
  path.length ≥ 1 ∧ path[0]! = start ∧ path[path.length - 1]! = target
-- !benchmark @end postcond_aux


@[reducible, simp]
def BfsShortestPath_postcond (graph : List (String × List String)) (start : String) (target : String) (result : Option (List String)) (h_precond : BfsShortestPath_precond graph start target) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none =>
    -- No valid path exists from start to target
    ¬ ∃ path, isValidPath graph path ∧ isPathFromTo path start target
  | some path =>
    -- The returned path is valid and goes from start to target
    isValidPath graph path ∧
    isPathFromTo path start target ∧
    -- It is a shortest such path
    (∀ other, isValidPath graph other → isPathFromTo other start target →
      path.length ≤ other.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem BfsShortestPath_spec_satisfied (graph : List (String × List String)) (start : String) (target : String) (h_precond : BfsShortestPath_precond graph start target) :
    BfsShortestPath_postcond graph start target (BfsShortestPath graph start target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof