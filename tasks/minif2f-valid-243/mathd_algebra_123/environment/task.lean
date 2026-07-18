import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Together, Amy and Betty have 20 apples. Amy has three times the number of apples that Betty has. How many more apples than Betty does Amy have? -/
theorem mathd_algebra_123 (a b : ℕ) (h₀ : 0 < a ∧ 0 < b) (h₁ : a + b = 20) (h₂ : a = 3 * b) :
    a - b = (10) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
