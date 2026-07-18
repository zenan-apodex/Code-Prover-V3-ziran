import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Find $x^2+y^2$ if $x$ and $y$ are positive integers such that \[xy+x+y = 71\qquad\text{and}\qquad x^2y+xy^2 = 880.\] -/
theorem aime_1991_p1 (x y : ℕ) (h₀ : 0 < x ∧ 0 < y) (h₁ : x * y + (x + y) = 71)
    (h₂ : x ^ 2 * y + x * y ^ 2 = 880) : x ^ 2 + y ^ 2 = (146) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
