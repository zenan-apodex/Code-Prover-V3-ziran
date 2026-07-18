-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def numCols (matrix : List (List Int)) : Nat :=
  match matrix with
  | [] => 0
  | row :: _ => row.length
-- !benchmark @end precond_aux

@[reducible, simp]
def SearchMatrix_precond (matrix : List (List Int)) (target : Int) : Prop :=
  -- !benchmark @start precond
  (∀ row ∈ matrix, row.length = numCols matrix) ∧
  (∀ row ∈ matrix, List.Pairwise (fun a b => a ≤ b) row) ∧
  (∀ i j : Nat, i + 1 < matrix.length → j < numCols matrix →
    (matrix[i]!)[j]! ≤ (matrix[i + 1]!)[j]!)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SearchMatrix (matrix : List (List Int)) (target : Int)
    (h_precond : SearchMatrix_precond (matrix) (target)) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SearchMatrix_postcond (matrix : List (List Int)) (target : Int) (result : Bool)
    (h_precond : SearchMatrix_precond (matrix) (target)) : Prop :=
  -- !benchmark @start postcond
  ((∃ i j : Nat, i < matrix.length ∧ j < numCols matrix ∧ (matrix[i]!)[j]! = target) ↔ result = true)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SearchMatrix_spec_satisfied (matrix : List (List Int)) (target : Int)
    (h_precond : SearchMatrix_precond (matrix) (target)) :
    SearchMatrix_postcond (matrix) (target) (SearchMatrix (matrix) (target) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof