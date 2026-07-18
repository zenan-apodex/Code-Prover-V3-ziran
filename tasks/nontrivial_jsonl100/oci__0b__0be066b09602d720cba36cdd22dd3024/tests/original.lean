-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
/-- Extract the set of node keys from the adjacency list. -/
def graphNodes (graph : List (Int × List Int)) : List Int :=
  graph.map Prod.fst

/-- Look up neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (Int × List Int)) (node : Int) : List Int :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- All edges in the graph as (src, dst) pairs. -/
def graphEdges (graph : List (Int × List Int)) : List (Int × Int) :=
  graph.flatMap (fun p => p.2.map (fun dst => (p.1, dst)))

/-- A graph is a DAG: there is no node reachable from itself via edges. -/
def isDAG (graph : List (Int × List Int)) : Prop :=
  ∀ cycle : List Int, cycle.length > 0 →
    (∀ i : Nat, i < cycle.length →
      (cycle[i]!, cycle[(i + 1) % cycle.length]!) ∈ graphEdges graph) →
    False

/-- All neighbor targets are also nodes in the graph. -/
def allTargetsAreNodes (graph : List (Int × List Int)) : Prop :=
  ∀ e ∈ graphEdges graph, e.2 ∈ graphNodes graph
-- !benchmark @end precond_aux

@[reducible, simp]
def TopologicalSortDfs_precond (graph : List (Int × List Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) graph ∧
  isDAG graph ∧
  allTargetsAreNodes graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def TopologicalSortDfs (graph : List (Int × List Int)) (h_precond : TopologicalSortDfs_precond graph) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Index of first occurrence of `x` in `xs`, or `xs.length` if absent. -/
def listIndexOf (xs : List Int) (x : Int) : Nat :=
  match xs with
  | [] => 0
  | h :: t => if h == x then 0 else 1 + listIndexOf t x
-- !benchmark @end postcond_aux


@[reducible, simp]
def TopologicalSortDfs_postcond (graph : List (Int × List Int)) (result : List Int) (h_precond : TopologicalSortDfs_precond graph) : Prop :=
  -- !benchmark @start postcond
  let nodes := graphNodes graph
  -- result is a permutation of the graph's node set
  result.length = nodes.length ∧
  (∀ n ∈ nodes, n ∈ result) ∧
  (∀ n ∈ result, n ∈ nodes) ∧
  List.Nodup result ∧
  -- topological order: for every edge u → v, u appears before v
  (∀ e ∈ graphEdges graph,
    listIndexOf result e.1 < listIndexOf result e.2)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem TopologicalSortDfs_spec_satisfied (graph : List (Int × List Int)) (h_precond : TopologicalSortDfs_precond graph) :
    TopologicalSortDfs_postcond graph (TopologicalSortDfs graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof