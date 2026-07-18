-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def BfsShortestPath_precond (graph : List (String × List String)) (start : String) (goal : String) : Prop :=
  -- !benchmark @start precond
  -- Keys are unique (graph is a valid adjacency list / dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def BfsShortestPath (graph : List (String × List String)) (start : String) (goal : String) (h_precond : BfsShortestPath_precond graph start goal) : Option (List String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up neighbors of a node in the adjacency list. Returns none if node not a key. -/
def graphLookup (graph : List (String × List String)) (node : String) : Option (List String) :=
  match graph.find? (fun p => p.1 == node) with
  | some p => some p.2
  | none => none

/-- A path is valid in the graph: every node is a key, and consecutive nodes are neighbors. -/
def isValidPath (graph : List (String × List String)) (path : List String) : Prop :=
  path.length ≥ 1 ∧
  (∀ n ∈ path, (graphLookup graph n).isSome) ∧
  (∀ i, i + 1 < path.length →
    match graphLookup graph (path[i]!) with
    | some neighbors => path[i+1]! ∈ neighbors
    | none => False)

/-- A path goes from start to goal -/
def pathFromTo (path : List String) (start goal : String) : Prop :=
  path.head? = some start ∧ path.getLast? = some goal
-- !benchmark @end postcond_aux


@[reducible, simp]
def BfsShortestPath_postcond (graph : List (String × List String)) (start : String) (goal : String) (result : Option (List String)) (h_precond : BfsShortestPath_precond graph start goal) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none =>
    -- If result is None, then either start or goal is not in the graph,
    -- or no valid path exists from start to goal
    (graphLookup graph start = none) ∨
    (graphLookup graph goal = none) ∨
    (¬ ∃ path, isValidPath graph path ∧ pathFromTo path start goal)
  | some path =>
    -- The path is valid, goes from start to goal
    isValidPath graph path ∧
    pathFromTo path start goal ∧
    -- It is a shortest such path
    (∀ other, isValidPath graph other → pathFromTo other start goal →
      path.length ≤ other.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem BfsShortestPath_spec_satisfied (graph : List (String × List String)) (start : String) (goal : String) (h_precond : BfsShortestPath_precond graph start goal) :
    BfsShortestPath_postcond graph start goal (BfsShortestPath graph start goal h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof