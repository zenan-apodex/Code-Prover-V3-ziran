import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
How many distinct, non-equilateral triangles with a perimeter of 60 units have integer side lengths $a$, $b$, and $c$ such that $a$, $b$, $c$ is an arithmetic sequence? -/
theorem mathd_algebra_144 (a b c d : ℕ) (h : 0 < a ∧ 0 < b ∧ 0 < c ∧ 0 < d) (h₀ : (c : ℤ) - b = d)
    (h₁ : (b : ℤ) - a = d) (h₂ : a + b + c = 60) (h₃ : a + b > c) : d < (10) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
