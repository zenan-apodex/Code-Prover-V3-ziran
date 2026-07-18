import Mathlib

def searchMatrix (matrix : List (List Int)) (target : Int) : Bool := sorry

def is_sorted_matrix (matrix : List (List Int)) : Bool := sorry

theorem search_empty_matrix (target : Int) :
  searchMatrix [] target = false ∧ 
  searchMatrix [[]] target = false :=
  sorry

theorem search_sorted_matrix_exists (rows cols base : Nat) 
  (h1 : 0 < rows) (h2 : 0 < cols) :
  ∀ (matrix : List (List Int)),
  is_sorted_matrix matrix →
  ∀ (i : Nat), i < rows * cols →
  let row := i / cols
  let col := i % cols
  searchMatrix matrix (((matrix.get! row).get!) col) = true :=
  sorry

theorem search_sorted_matrix_between (rows cols base : Nat)
  (h1 : 0 < rows) (h2 : 0 < cols) (h3 : rows * cols > 1) :
  ∀ (matrix : List (List Int)),
  is_sorted_matrix matrix →
  ∀ (i : Nat), i + 1 < rows * cols →
  let flat := matrix.join
  let curr := flat.get! i 
  let next := flat.get! (i+1)
  next - curr > 1 →
  searchMatrix matrix (curr + 1) = false :=
  sorry

theorem search_consistent_matrix (matrix : List (List Int)) (target : Int)
  (h1 : ∀ row ∈ matrix, row.length = matrix.head!.length) :
  is_sorted_matrix matrix →
  searchMatrix matrix target = 
    matrix.any (List.contains · target) :=
  sorry
