-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LargestSquareSubmatrix_precond (A : List (List Int)) : Prop :=
  -- !benchmark @start precond
  -- All entries are 0 or 1
  ∀ row ∈ A, ∀ x ∈ row, x = 0 ∨ x = 1
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LargestSquareSubmatrix (A : List (List Int)) (h_precond : LargestSquareSubmatrix_precond A) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Check whether the square submatrix of size `s` starting at row `r`, col `c` in matrix `A`
    consists entirely of 1s. -/
def allOnesSquare (A : List (List Int)) (r c s : Nat) : Prop :=
  s > 0 ∧
  r + s ≤ A.length ∧
  (∀ i, i < s → c + s ≤ (A[r + i]!).length) ∧
  (∀ i j, i < s → j < s → (A[r + i]!)[c + j]! = 1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LargestSquareSubmatrix_postcond (A : List (List Int)) (result : Int) (h_precond : LargestSquareSubmatrix_precond A) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- If result > 0, there exists a square of that size with all 1s
  (result > 0 → ∃ r c : Nat, allOnesSquare A r c result.toNat) ∧
  -- No square of size result + 1 exists with all 1s
  (¬ ∃ r c : Nat, allOnesSquare A r c (result.toNat + 1)) ∧
  -- If result = 0, then there is no square of size 1 with all 1s (i.e., no 1 in the matrix)
  (result = 0 → ¬ ∃ r c : Nat, allOnesSquare A r c 1)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LargestSquareSubmatrix_spec_satisfied (A : List (List Int)) (h_precond : LargestSquareSubmatrix_precond A) :
    LargestSquareSubmatrix_postcond A (LargestSquareSubmatrix A h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof