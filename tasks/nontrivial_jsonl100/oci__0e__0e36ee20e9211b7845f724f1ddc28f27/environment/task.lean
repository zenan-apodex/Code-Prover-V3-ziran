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
  -- Keys are pairwise distinct (acts like a dict)
  List.Pairwise (fun a b => a.1 ≠ b.1) graph
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def HasCycle (graph : List (Int × List Int)) (h_precond : HasCycle_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Look up neighbors of a node in the adjacency list. -/
def graphNeighbors (graph : List (Int × List Int)) (node : Int) : List Int :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

/-- A walk in the graph: a non-empty list of nodes where each consecutive pair is an edge. -/
def isWalk (graph : List (Int × List Int)) (walk : List Int) : Prop :=
  walk.length ≥ 1 ∧
  ∀ i, i + 1 < walk.length → walk[i + 1]! ∈ graphNeighbors graph walk[i]!

/-- A cycle is a walk of length ≥ 2 where the first and last nodes are the same. -/
def hasCycleInGraph (graph : List (Int × List Int)) : Prop :=
  ∃ walk : List Int, isWalk graph walk ∧ walk.length ≥ 2 ∧ walk.head! = walk.getLast!
-- !benchmark @end postcond_aux


@[reducible, simp]
def HasCycle_postcond (graph : List (Int × List Int)) (result : Bool) (h_precond : HasCycle_precond graph) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ hasCycleInGraph graph
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem HasCycle_spec_satisfied (graph : List (Int × List Int)) (h_precond : HasCycle_precond graph) :
    HasCycle_postcond graph (HasCycle graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof