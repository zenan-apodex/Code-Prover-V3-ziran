-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
/-- Extract the set of all node keys from the graph. -/
def graphNodes (graph : List (Int × List Int)) : List Int :=
  graph.map Prod.fst

/-- Keys are pairwise distinct (acts like a dict). -/
def graphKeysUnique (graph : List (Int × List Int)) : Prop :=
  List.Pairwise (fun a b => a.1 ≠ b.1) graph

/-- Look up adjacency list for a node. -/
def graphLookup (graph : List (Int × List Int)) (node : Int) : List Int :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- All neighbors referenced in adjacency lists are themselves keys in the graph. -/
def graphClosed (graph : List (Int × List Int)) : Prop :=
  ∀ p ∈ graph, ∀ n ∈ p.2, n ∈ graphNodes graph
-- !benchmark @end precond_aux

@[reducible, simp]
def TopologicalSort_precond (graph : List (Int × List Int)) : Prop :=
  -- !benchmark @start precond
  graphKeysUnique graph ∧ graphClosed graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def TopologicalSort (graph : List (Int × List Int)) (h_precond : TopologicalSort_precond graph) : Option (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- There is a directed edge from u to v in the graph. -/
def hasEdge (graph : List (Int × List Int)) (u v : Int) : Prop :=
  v ∈ graphLookup graph u
-- !benchmark @end postcond_aux


@[reducible, simp]
def TopologicalSort_postcond (graph : List (Int × List Int)) (result : Option (List Int))
    (h_precond : TopologicalSort_precond graph) : Prop :=
  -- !benchmark @start postcond
  let nodes := graphNodes graph
  match result with
  | none =>
    -- If None is returned, the graph contains a cycle:
    -- there is no permutation of nodes that is a valid topological order
    ¬ ∃ order : List Int, order.Perm nodes ∧
      (∀ u v, hasEdge graph u v →
        ∃ i j, i < order.length ∧ j < order.length ∧
          order[i]! = u ∧ order[j]! = v ∧ i < j)
  | some order =>
    -- The result is a permutation of the graph's nodes
    order.Perm nodes ∧
    -- No duplicate nodes in the result
    order.Nodup ∧
    -- Topological ordering: for every edge u → v, u appears before v
    (∀ u v, hasEdge graph u v →
      ∀ i j, i < order.length → j < order.length →
        order[i]! = u → order[j]! = v → i < j)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem TopologicalSort_spec_satisfied (graph : List (Int × List Int))
    (h_precond : TopologicalSort_precond graph) :
    TopologicalSort_postcond graph (TopologicalSort graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof