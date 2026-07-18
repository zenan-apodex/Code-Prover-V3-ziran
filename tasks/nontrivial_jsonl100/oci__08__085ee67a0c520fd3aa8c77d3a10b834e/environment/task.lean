-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MaxTrees_precond (m : Nat) (n : Nat) (field : List (List Int)) : Prop :=
  -- !benchmark @start precond
  field.length = m ∧ (∀ row ∈ field, row.length = n)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MaxTrees (m : Nat) (n : Nat) (field : List (List Int)) (h_precond : MaxTrees_precond m n field) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- An independent set on an m×n grid: a set of cells where no two are horizontally
    or vertically adjacent. Represented as a list of (row, col) pairs. -/
def isIndependentSet (m n : Nat) (cells : List (Nat × Nat)) : Prop :=
  -- all cells are in bounds
  (∀ c ∈ cells, c.1 < m ∧ c.2 < n) ∧
  -- no duplicates
  cells.Nodup ∧
  -- no two selected cells are adjacent
  (∀ c1 ∈ cells, ∀ c2 ∈ cells, c1 ≠ c2 →
    ¬ ((c1.1 = c2.1 ∧ (c1.2 + 1 = c2.2 ∨ c2.2 + 1 = c1.2)) ∨
       (c1.2 = c2.2 ∧ (c1.1 + 1 = c2.1 ∨ c2.1 + 1 = c1.1))))
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxTrees_postcond (m : Nat) (n : Nat) (field : List (List Int)) (result : Nat) (h_precond : MaxTrees_precond m n field) : Prop :=
  -- !benchmark @start postcond
  -- There exists an independent set of size `result`
  (∃ cells : List (Nat × Nat), cells.length = result ∧ isIndependentSet m n cells) ∧
  -- No independent set can be larger than `result`
  (∀ cells : List (Nat × Nat), isIndependentSet m n cells → cells.length ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MaxTrees_spec_satisfied (m : Nat) (n : Nat) (field : List (List Int)) (h_precond : MaxTrees_precond m n field) :
    MaxTrees_postcond m n field (MaxTrees m n field h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof