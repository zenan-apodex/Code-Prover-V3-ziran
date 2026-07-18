import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let \[f(x) = \begin{cases}
-x^2 - 1 &\text{if }x< 0, \\
2&\text{if }0 \le x< 4, \\
\sqrt{x}&\text{if }x \ge 4.
\end{cases}
\]Find $f(\pi)$. -/
theorem mathd_algebra_480 (f : ℝ → ℝ) (h₀ : ∀ x < 0, f x = -x ^ 2 - 1)
    (h₁ : ∀ x, 0 ≤ x ∧ x < 4 → f x = 2) (h₂ : ∀ x ≥ 4, f x = Real.sqrt x) : f π = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
