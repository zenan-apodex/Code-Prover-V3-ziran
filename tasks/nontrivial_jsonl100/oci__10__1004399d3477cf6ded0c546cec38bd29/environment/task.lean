-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsCyclicUtil_precond (graph : List (Nat × List Nat)) : Prop :=
  -- !benchmark @start precond
  -- Keys are pairwise distinct (acts like a dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph ∧
  -- All adjacency targets are valid keys
  (∀ p ∈ graph, ∀ v ∈ p.2, ∃ q ∈ graph, q.1 = v)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsCyclicUtil (graph : List (Nat × List Nat)) (h_precond : IsCyclicUtil_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up adjacency list for node `v` in the graph. -/
def graphLookup' (graph : List (Nat × List Nat)) (v : Nat) : List Nat :=
  match graph.find? (fun p => p.1 == v) with
  | some p => p.2
  | none => []

/-- A walk in the graph: a list of nodes where each consecutive pair has an edge. -/
def isWalk' (graph : List (Nat × List Nat)) : List Nat → Prop
  | [] => True
  | [_] => True
  | u :: v :: rest => v ∈ graphLookup' graph u ∧ isWalk' graph (v :: rest)

/-- The graph has a cycle iff there exists a non-empty walk that starts and ends at the same node. -/
def hasCycle' (graph : List (Nat × List Nat)) : Prop :=
  ∃ (walk : List Nat), walk.length ≥ 2 ∧
    isWalk' graph walk ∧
    walk.head? = walk.getLast?
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsCyclicUtil_postcond (graph : List (Nat × List Nat)) (result : Bool) (h_precond : IsCyclicUtil_precond graph) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ hasCycle' graph
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsCyclicUtil_spec_satisfied (graph : List (Nat × List Nat)) (h_precond : IsCyclicUtil_precond graph) :
    IsCyclicUtil_postcond graph (IsCyclicUtil graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof