-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def DetectCycle_precond (graph : List (Nat × List Nat)) : Prop :=
  -- !benchmark @start precond
  -- Keys are pairwise distinct (acts like a dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def DetectCycle (graph : List (Nat × List Nat)) (h_precond : DetectCycle_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up the neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (Nat × List Nat)) (node : Nat) : List Nat :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A walk in the graph: a nonempty list of nodes where each consecutive pair is an edge. -/
def isWalk (graph : List (Nat × List Nat)) (walk : List Nat) : Prop :=
  walk.length ≥ 1 ∧
  ∀ i, i + 1 < walk.length → walk[i + 1]! ∈ graphNeighbors graph walk[i]!

/-- The graph has a cycle iff there is a walk of length ≥ 2 whose first and last nodes coincide. -/
def hasCycle (graph : List (Nat × List Nat)) : Prop :=
  ∃ walk : List Nat, walk.length ≥ 2 ∧ isWalk graph walk ∧ walk[0]! = walk[walk.length - 1]!
-- !benchmark @end postcond_aux


@[reducible, simp]
def DetectCycle_postcond (graph : List (Nat × List Nat)) (result : Bool) (h_precond : DetectCycle_precond graph) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ hasCycle graph
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem DetectCycle_spec_satisfied (graph : List (Nat × List Nat)) (h_precond : DetectCycle_precond graph) :
    DetectCycle_postcond graph (DetectCycle graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof