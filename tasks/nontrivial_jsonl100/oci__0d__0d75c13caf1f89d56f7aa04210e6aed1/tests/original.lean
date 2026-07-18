-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def FindLargestSquare_precond (matrix : List (List Int)) : Prop :=
  -- !benchmark @start precond
  -- All rows have the same length (rectangular matrix), and all entries are 0 or 1
  (∀ row ∈ matrix, row.length = (matrix[0]!).length) ∧
  (∀ row ∈ matrix, ∀ x ∈ row, x = 0 ∨ x = 1)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def FindLargestSquare (matrix : List (List Int)) (h_precond : FindLargestSquare_precond matrix) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Returns true iff the square submatrix of side `s` with top-left corner `(r, c)` consists entirely of 1s. -/
def allOnesSquare (matrix : List (List Int)) (r c s : Nat) : Prop :=
  s > 0 ∧
  r + s ≤ matrix.length ∧
  (∀ row ∈ matrix, c + s ≤ row.length) ∧
  ∀ i, ∀ j, i < s → j < s →
    (matrix[r + i]!)[c + j]! = 1

/-- There exists an all-ones square of side `s` in the matrix. -/
def existsSquareOfSide (matrix : List (List Int)) (s : Nat) : Prop :=
  ∃ r c, allOnesSquare matrix r c s
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindLargestSquare_postcond (matrix : List (List Int)) (result : Int) (h_precond : FindLargestSquare_precond matrix) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  ∃ s : Nat, result = (s * s : Nat) ∧
    -- If s > 0, there exists such a square
    (s > 0 → existsSquareOfSide matrix s) ∧
    -- If s = 0, there is no all-ones square of side 1
    (s = 0 → ¬ existsSquareOfSide matrix 1) ∧
    -- No larger square exists
    (∀ t : Nat, t > s → ¬ existsSquareOfSide matrix t)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem FindLargestSquare_spec_satisfied (matrix : List (List Int)) (h_precond : FindLargestSquare_precond matrix) :
    FindLargestSquare_postcond matrix (FindLargestSquare matrix h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof