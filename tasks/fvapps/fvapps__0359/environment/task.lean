import Mathlib

def Matrix (α : Type) := List (List α)

def List.sum (xs : List Int) : Int := 
  match xs with
  | [] => 0
  | (x::xs) => x + xs.sum

def minFallingPathSum (matrix : Matrix Int) : Int :=
  sorry

def isValidMatrix (matrix : Matrix Int) : Bool :=
  match matrix with
  | [] => false
  | r::_ => let n := r.length
            matrix.all (fun row => row.length == n)

theorem min_falling_path_sum_bounded_by_row_extremes {matrix : Matrix Int} 
  (h : isValidMatrix matrix = true) :
  minFallingPathSum matrix ≤ (matrix.map (fun row => row.maximum?.getD 0)).sum ∧ 
  minFallingPathSum matrix ≥ (matrix.map (fun row => row.minimum?.getD 0)).sum :=
sorry

theorem single_column_matrix_sum {matrix : Matrix Int}
  (h1 : matrix.all (fun row => row.length = 1) = true)
  (h2 : matrix.length > 0) :
  minFallingPathSum matrix = (matrix.map (fun row => row.head!)).sum :=
sorry

theorem falling_path_bounded_by_first_last_rows {matrix : Matrix Int}
  (h : isValidMatrix matrix = true) 
  (h2 : matrix.length > 0) :
  minFallingPathSum matrix ≥ 
    (matrix.head!.minimum?.getD 0) + 
    (matrix.tail.map (fun row => row.minimum?.getD 0)).sum ∧
  minFallingPathSum matrix ≤ 
    (matrix.head!.maximum?.getD 0) + 
    (matrix.dropLast.tail.map (fun row => row.maximum?.getD 0)).sum +
    (matrix.getLast?.getD []).maximum?.getD 0 :=
sorry
