import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Solve the equation $\cos^2{x}+\cos^2{2x}+\cos^2{3x}=1$ -/
theorem imo_1962_p4 (S : Set ℝ)
    (h₀ : S = {x : ℝ | Real.cos x ^ 2 + Real.cos (2 * x) ^ 2 + Real.cos (3 * x) ^ 2 = 1}) :
    S = ({x : ℝ | ∃ m : ℤ, x = π / 2 + m * π ∨ x = π / 4 + m * π / 2 ∨
      x = π / 6 + m * π ∨ x = 5 * π / 6 + m * π}) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
