-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def HasCycle_precond (graph : List (Int × List Int)) : Prop :=
  -- !benchmark @start precond
  -- Keys are pairwise distinct (well-formed adjacency list / dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def HasCycle (graph : List (Int × List Int)) (h_precond : HasCycle_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- The set of nodes that are keys in the graph. -/
def graphNodes (graph : List (Int × List Int)) : List Int :=
  graph.map Prod.fst

/-- Look up neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (Int × List Int)) (v : Int) : List Int :=
  match graph.find? (fun p => p.1 == v) with
  | some p => p.2
  | none => []

/-- A walk in the graph: a list of nodes where each consecutive pair is an edge. -/
def isWalk (graph : List (Int × List Int)) : List Int → Prop
  | [] => True
  | [_] => True
  | u :: v :: rest => v ∈ graphNeighbors graph u ∧ isWalk graph (v :: rest)

/-- A cycle exists: there is a walk of length ≥ 2 that starts and ends at the same node,
    with all intermediate nodes being graph nodes. -/
def hasCycleInGraph (graph : List (Int × List Int)) : Prop :=
  ∃ (walk : List Int),
    walk.length ≥ 2 ∧
    isWalk graph walk ∧
    walk.head? = walk.getLast? ∧
    (∀ v ∈ walk, v ∈ graphNodes graph)
-- !benchmark @end postcond_aux


@[reducible, simp]
def HasCycle_postcond (graph : List (Int × List Int)) (result : Bool)
    (h_precond : HasCycle_precond graph) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ hasCycleInGraph graph)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem HasCycle_spec_satisfied (graph : List (Int × List Int))
    (h_precond : HasCycle_precond graph) :
    HasCycle_postcond graph (HasCycle graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof