-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def FindAllPaths_precond (graph : List (List Nat)) (source : Nat) (destination : Nat) : Prop :=
  -- !benchmark @start precond
  source < graph.length ∧ destination < graph.length ∧
  -- all neighbors are valid vertices
  (∀ i, i < graph.length → ∀ v ∈ graph[i]!, v < graph.length)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def FindAllPaths (graph : List (List Nat)) (source : Nat) (destination : Nat) (h_precond : FindAllPaths_precond graph source destination) : List (List Nat) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A path is valid in the graph: consecutive vertices are connected by edges. -/
def isValidPath (graph : List (List Nat)) (path : List Nat) : Prop :=
  path.length ≥ 1 ∧
  (∀ i, i + 1 < path.length → path[i + 1]! ∈ (graph[path[i]!]!)) ∧
  (∀ v ∈ path, v < graph.length)

/-- Check that a path goes from source to destination -/
def isPathFromTo (path : List Nat) (source destination : Nat) : Prop :=
  path.head? = some source ∧ path.getLast? = some destination

/-- No repeated vertices in a path (simple path) -/
def isSimplePath (path : List Nat) : Prop :=
  path.Nodup
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindAllPaths_postcond (graph : List (List Nat)) (source : Nat) (destination : Nat) (result : List (List Nat)) (h_precond : FindAllPaths_precond graph source destination) : Prop :=
  -- !benchmark @start postcond
  -- Every returned path is a valid simple path from source to destination
  (∀ p ∈ result, isValidPath graph p ∧ isPathFromTo p source destination ∧ isSimplePath p) ∧
  -- Every valid simple path from source to destination is in the result
  (∀ p, isValidPath graph p → isPathFromTo p source destination → isSimplePath p → p ∈ result) ∧
  -- No duplicate paths in the result
  result.Nodup
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem FindAllPaths_spec_satisfied (graph : List (List Nat)) (source : Nat) (destination : Nat) (h_precond : FindAllPaths_precond graph source destination) :
    FindAllPaths_postcond graph source destination (FindAllPaths graph source destination h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof