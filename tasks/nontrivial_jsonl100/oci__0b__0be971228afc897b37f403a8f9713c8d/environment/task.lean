-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsPathExist_precond (matrix : List (List Int)) : Prop :=
  -- !benchmark @start precond
  matrix.length ≥ 1 ∧
  (∀ row ∈ matrix, row.length = (matrix[0]!).length) ∧
  (matrix[0]!).length ≥ 1 ∧
  (∀ row ∈ matrix, ∀ v ∈ row, v = 0 ∨ v = 1)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsPathExist (matrix : List (List Int)) (h_precond : IsPathExist_precond matrix) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A path from (0,0) to (m-1,n-1) using only right and down moves through 0-cells. -/
def IsValidPath (matrix : List (List Int)) (path : List (Nat × Nat)) : Prop :=
  let m := matrix.length
  let n := (matrix[0]!).length
  path.length ≥ 1 ∧
  path[0]! = (0, 0) ∧
  path[path.length - 1]! = (m - 1, n - 1) ∧
  (∀ (k : Nat), k < path.length →
    let p := path[k]!
    p.1 < m ∧ p.2 < n ∧ (matrix[p.1]!)[p.2]! = 0) ∧
  (∀ (k : Nat), k + 1 < path.length →
    let cur := path[k]!
    let nxt := path[k + 1]!
    (nxt.1 = cur.1 ∧ nxt.2 = cur.2 + 1) ∨
    (nxt.1 = cur.1 + 1 ∧ nxt.2 = cur.2))
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPathExist_postcond (matrix : List (List Int)) (result : Bool) (h_precond : IsPathExist_precond matrix) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ ∃ path : List (Nat × Nat), IsValidPath matrix path
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsPathExist_spec_satisfied (matrix : List (List Int)) (h_precond : IsPathExist_precond matrix) :
    IsPathExist_postcond matrix (IsPathExist matrix h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof