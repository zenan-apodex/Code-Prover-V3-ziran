import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- The product of three consecutive integers is 720. What is the largest of these integers? -/
theorem mathd_numbertheory_326 (n : ℕ) (h₀ : (↑n - 1) * ↑n * (↑n + 1) = (720 : ℤ)) : n + 1 = (10) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
