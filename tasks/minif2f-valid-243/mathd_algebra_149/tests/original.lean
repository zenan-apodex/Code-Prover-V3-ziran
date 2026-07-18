import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let \[f(x) =
\begin{cases}
x^2+9 &\text{if }x<-5, \\
3x-8&\text{if }x\ge-5.
\end{cases}
\]If $f(x)=10$, find the sum of all possible values of $x$. -/
theorem mathd_algebra_149 (f : ℝ → ℝ) (h₀ : ∀ x < -5, f x = x ^ 2 + 5)
    (h₁ : ∀ x ≥ -5, f x = 3 * x - 8) (h₂ : Fintype (f ⁻¹' {10})) :
    ∑ k ∈ (f ⁻¹' {10}).toFinset, k = (6) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
