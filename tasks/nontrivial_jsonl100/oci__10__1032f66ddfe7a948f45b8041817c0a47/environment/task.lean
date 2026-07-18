-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
/-- Look up neighbors of a node in the adjacency list. -/
def adjLookup (graph : List (Int × List Int)) (node : Int) : List Int :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A path is valid in the graph: consecutive nodes are connected by edges. -/
def isValidPath (graph : List (Int × List Int)) (path : List Int) : Prop :=
  ∀ i, i + 1 < path.length → (path[i + 1]!) ∈ adjLookup graph (path[i]!)
-- !benchmark @end precond_aux

@[reducible, simp]
def BfsShortestPath_precond (graph : List (Int × List Int)) (start : Int) (goal : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def BfsShortestPath (graph : List (Int × List Int)) (start : Int) (goal : Int) (h_precond : BfsShortestPath_precond graph start goal) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def BfsShortestPath_postcond (graph : List (Int × List Int)) (start : Int) (goal : Int) (result : List Int) (h_precond : BfsShortestPath_precond graph start goal) : Prop :=
  -- !benchmark @start postcond
  -- Case 1: result is empty means no path exists
  (result = [] →
    ¬ ∃ path : List Int, path.length ≥ 1 ∧ path.head! = start ∧ path.getLast! = goal ∧ isValidPath graph path) ∧
  -- Case 2: result is non-empty means it is a valid shortest path
  (result ≠ [] →
    -- result starts at start and ends at goal
    result.head! = start ∧
    result.getLast! = goal ∧
    -- result is a valid path in the graph
    isValidPath graph result ∧
    -- result is shortest: no valid path from start to goal is shorter
    (∀ other : List Int, other.length ≥ 1 → other.head! = start → other.getLast! = goal →
      isValidPath graph other → result.length ≤ other.length))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem BfsShortestPath_spec_satisfied (graph : List (Int × List Int)) (start : Int) (goal : Int) (h_precond : BfsShortestPath_precond graph start goal) :
    BfsShortestPath_postcond graph start goal (BfsShortestPath graph start goal h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof