import Mathlib

structure Matrix (α : Type) (n : Nat) where
  data : Array (Array α)
  dim_rows : data.size = n
  dim_cols : ∀ i < n, (data.get! i).size = n

def matrix_mult {n : Nat} (A B : Matrix Int n) : Matrix Int n where
  data := sorry
  dim_rows := sorry
  dim_cols := sorry

def numpy_matmul {n : Nat} (A B : Matrix Int n) : Matrix Int n where
  data := sorry
  dim_rows := sorry
  dim_cols := sorry

def identity_matrix (n : Nat) : Matrix Int n where
  data := sorry
  dim_rows := sorry
  dim_cols := sorry

theorem matrix_mult_matches_numpy {n : Nat} (A B : Matrix Int n) :
  matrix_mult A B = numpy_matmul A B := by sorry

theorem matrix_mult_identity {n : Nat} (A : Matrix Int n) :
  matrix_mult A (identity_matrix n) = A := by sorry

theorem matrix_mult_associative {n : Nat} (A B C : Matrix Int n) :
  matrix_mult (matrix_mult A B) C = matrix_mult A (matrix_mult B C) := by sorry

theorem matrix_mult_dimensions {n : Nat} (A B : Matrix Int n) :
  let C := matrix_mult A B
  C.data.size = n ∧ ∀ i < n, (C.data.get! i).size = n := by sorry
