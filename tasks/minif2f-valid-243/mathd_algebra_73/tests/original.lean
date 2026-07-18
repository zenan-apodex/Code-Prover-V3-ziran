import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $p$, $q$, and $r$ be constants. One solution to the equation $(x-p)(x-q) = (r-p)(r-q)$ is $x=r$. Find the other solution in terms of $p$, $q$, and $r$. -/
theorem mathd_algebra_73 (p q r x : ℂ) (h₀ : (x - p) * (x - q) = (r - p) * (r - q)) (h₁ : x ≠ r) :
    x = (p + q - r) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
