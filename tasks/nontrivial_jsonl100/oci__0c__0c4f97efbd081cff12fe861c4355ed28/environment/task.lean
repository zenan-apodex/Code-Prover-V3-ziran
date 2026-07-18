-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def graphGet (graph : List (List Int)) (i j : Nat) : Int :=
  match graph[i]? with
  | some row => match row[j]? with
    | some v => v
    | none => 0
  | none => 0
-- !benchmark @end precond_aux

@[reducible, simp]
def IsBipartite_precond (graph : List (List Int)) : Prop :=
  -- !benchmark @start precond
  let n := graph.length
  n ≥ 1 ∧
  (∀ row ∈ graph, row.length = n) ∧
  -- symmetric: graph[i][j] = graph[j][i]
  (∀ i j, i < n → j < n → graphGet graph i j = graphGet graph j i) ∧
  -- no self-loops: graph[i][i] = 0
  (∀ i, i < n → graphGet graph i i = 0) ∧
  -- entries are 0 or 1
  (∀ i j, i < n → j < n → (graphGet graph i j = 0 ∨ graphGet graph i j = 1))
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsBipartite (graph : List (List Int)) (h_precond : IsBipartite_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def colorGet (color : List Nat) (i : Nat) : Nat :=
  match color[i]? with
  | some v => v
  | none => 0

def IsBipartiteGraph (graph : List (List Int)) : Prop :=
  let n := graph.length
  ∃ color : List Nat,
    color.length = n ∧
    (∀ i, i < n → (colorGet color i = 0 ∨ colorGet color i = 1)) ∧
    (∀ i j, i < n → j < n → graphGet graph i j = 1 → colorGet color i ≠ colorGet color j)
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsBipartite_postcond (graph : List (List Int)) (result : Bool) (h_precond : IsBipartite_precond graph) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ IsBipartiteGraph graph)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsBipartite_spec_satisfied (graph : List (List Int)) (h_precond : IsBipartite_precond graph) :
    IsBipartite_postcond graph (IsBipartite graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof