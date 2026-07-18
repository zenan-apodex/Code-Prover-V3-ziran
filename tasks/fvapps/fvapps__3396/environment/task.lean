import Mathlib

structure Matrix (α : Type) (n : Nat) where
  data : Array (Array α)
  size_rows : data.size = n
  size_cols : ∀ i, i < n → data[i]!.size = n

def matrixAddition {n : Nat} (A B : Matrix Int n) : Matrix Int n :=
  sorry

theorem matrixAddition_commutativity {n : Nat} (A B : Matrix Int n) :
  ∀ i j, i < n → j < n →
    (matrixAddition A B).data[i]!.get! j = (matrixAddition B A).data[i]!.get! j := by
  sorry

theorem matrixAddition_correctness {n : Nat} (A B : Matrix Int n) :
  ∀ i j, i < n → j < n →
    (matrixAddition A B).data[i]!.get! j = A.data[i]!.get! j + B.data[i]!.get! j := by
  sorry

def zeroMatrix (n : Nat) : Matrix Int n :=
  sorry

theorem matrixAddition_identity {n : Nat} (A : Matrix Int n) :
  matrixAddition A (zeroMatrix n) = A := by
  sorry
