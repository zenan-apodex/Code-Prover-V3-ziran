import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $x$, $y$, and $z$ are positive real numbers satisfying: \begin{align*}
\log x - \log y &= a, \\
\log y - \log z &= 15, \text{ and} \\
\log z - \log x &= -7, \\
\end{align*}where $a$ is a real number, what is $a$? -/
theorem mathd_algebra_96 (x y z a : ℝ) (h₀ : 0 < x ∧ 0 < y ∧ 0 < z)
    (h₁ : Real.log x - Real.log y = a) (h₂ : Real.log y - Real.log z = 15)
    (h₃ : Real.log z - Real.log x = -7) : a = (-8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
