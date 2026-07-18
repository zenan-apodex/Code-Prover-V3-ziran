-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def RearrangeMatrix_precond (matrix : List (List Int)) : Prop :=
  -- !benchmark @start precond
  matrix.length ≥ 1 ∧
  (∀ row ∈ matrix, row.length = matrix[0]!.length) ∧
  matrix[0]!.length ≥ 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def RearrangeMatrix (matrix : List (List Int)) (h_precond : RearrangeMatrix_precond matrix) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Flatten a list of lists into a single list -/
def flattenMatrix (m : List (List Int)) : List Int :=
  m.flatMap id

/-- Get column j from a matrix -/
def getColumn (m : List (List Int)) (j : Nat) : List Int :=
  m.map (fun row => row[j]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def RearrangeMatrix_postcond (matrix : List (List Int)) (result : List (List Int)) (h_precond : RearrangeMatrix_precond matrix) : Prop :=
  -- !benchmark @start postcond
  let n := matrix.length
  let m := matrix[0]!.length
  -- Same dimensions
  result.length = n ∧
  (∀ row ∈ result, row.length = m) ∧
  -- Each row is sorted in non-decreasing order
  (∀ row ∈ result, List.Pairwise (· ≤ ·) row) ∧
  -- Each column is sorted in non-decreasing order
  (∀ j : Nat, j < m → List.Pairwise (· ≤ ·) (getColumn result j)) ∧
  -- The multiset of elements is preserved
  (flattenMatrix result).Perm (flattenMatrix matrix)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem RearrangeMatrix_spec_satisfied (matrix : List (List Int)) (h_precond : RearrangeMatrix_precond matrix) :
    RearrangeMatrix_postcond matrix (RearrangeMatrix matrix h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof