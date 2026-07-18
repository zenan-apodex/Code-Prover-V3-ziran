import Mathlib

def sumTriangularNumbers (n : Int) : Int :=
  sorry

theorem sum_triangular_negative_returns_zero {n : Int}
  (h : n ≤ 0) : sumTriangularNumbers n = 0 := sorry

theorem sum_triangular_positive_properties {n : Int} 
  (h : n > 0) : 
  sumTriangularNumbers n > 0 ∧ 
  sumTriangularNumbers n = n * (n + 1) * (n + 2) / 6 := sorry

theorem sum_triangular_increasing {n : Int}
  (h : n > 1) : sumTriangularNumbers n > sumTriangularNumbers (n-1) := sorry
