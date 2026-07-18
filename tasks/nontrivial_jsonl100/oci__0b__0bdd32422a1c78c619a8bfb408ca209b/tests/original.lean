-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def neighbors (graph : List (Nat × List Nat)) (node : Nat) : List Nat :=
  match graph.find? (fun p => p.1 == node) with
  | some p => p.2
  | none => []

def isValidPath (graph : List (Nat × List Nat)) (path : List Nat) : Prop :=
  match path with
  | [] => False
  | [_] => True
  | a :: b :: rest =>
    b ∈ neighbors graph a ∧ isValidPath graph (b :: rest)

def isSimplePath (path : List Nat) : Prop :=
  path.Nodup
-- !benchmark @end precond_aux

@[reducible, simp]
def FindAllPaths_precond (graph : List (Nat × List Nat)) (start_node : Nat) (end_node : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def FindAllPaths (graph : List (Nat × List Nat)) (start_node : Nat) (end_node : Nat) (h_precond : FindAllPaths_precond graph start_node end_node) : List (List Nat) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def FindAllPaths_postcond (graph : List (Nat × List Nat)) (start_node : Nat) (end_node : Nat) (result : List (List Nat)) (h_precond : FindAllPaths_precond graph start_node end_node) : Prop :=
  -- !benchmark @start postcond
  -- Every path in result is valid: starts at start_node, ends at end_node, is a valid graph path, and is simple
  (∀ path, path ∈ result →
    path.head? = some start_node ∧
    path.getLast? = some end_node ∧
    isValidPath graph path ∧
    isSimplePath path) ∧
  -- Completeness: every simple valid path from start to end is in the result
  (∀ path, path.head? = some start_node →
    path.getLast? = some end_node →
    isValidPath graph path →
    isSimplePath path →
    path ∈ result) ∧
  -- No duplicates in result
  result.Nodup
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem FindAllPaths_spec_satisfied (graph : List (Nat × List Nat)) (start_node : Nat) (end_node : Nat) (h_precond : FindAllPaths_precond graph start_node end_node) :
    FindAllPaths_postcond graph start_node end_node (FindAllPaths graph start_node end_node h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof