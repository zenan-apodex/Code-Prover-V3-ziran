-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def validEdges (n : Nat) (edges : List (Nat × Nat)) : Prop :=
  ∀ e ∈ edges, 1 ≤ e.1 ∧ e.1 ≤ n ∧ 1 ≤ e.2 ∧ e.2 ≤ n

def validQueries (n : Nat) (queries : List (Nat × Nat)) : Prop :=
  ∀ q ∈ queries, 1 ≤ q.1 ∧ q.1 ≤ n ∧ 1 ≤ q.2 ∧ q.2 ≤ n
-- !benchmark @end precond_aux

@[reducible, simp]
def HasPathBfs_precond (n : Nat) (edges : List (Nat × Nat)) (queries : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ validEdges n edges ∧ validQueries n queries
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def HasPathBfs (n : Nat) (edges : List (Nat × Nat)) (queries : List (Nat × Nat)) (h_precond : HasPathBfs_precond n edges queries) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Two nodes are connected if there is a path between them using the undirected edges. -/
inductive Reachable (edges : List (Nat × Nat)) : Nat → Nat → Prop where
  | refl (u : Nat) : Reachable edges u u
  | step (u v w : Nat) : Reachable edges u v → ((v, w) ∈ edges ∨ (w, v) ∈ edges) → Reachable edges u w
-- !benchmark @end postcond_aux


@[reducible, simp]
def HasPathBfs_postcond (n : Nat) (edges : List (Nat × Nat)) (queries : List (Nat × Nat)) (result : List String) (h_precond : HasPathBfs_precond n edges queries) : Prop :=
  -- !benchmark @start postcond
  result.length = queries.length ∧
  ∀ i, i < queries.length →
    let q := queries[i]!
    let r := result[i]!
    (Reachable edges q.1 q.2 ↔ r = "Yes") ∧
    (¬ Reachable edges q.1 q.2 ↔ r = "No") ∧
    (r = "Yes" ∨ r = "No")
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem HasPathBfs_spec_satisfied (n : Nat) (edges : List (Nat × Nat)) (queries : List (Nat × Nat)) (h_precond : HasPathBfs_precond n edges queries) :
    HasPathBfs_postcond n edges queries (HasPathBfs n edges queries h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof