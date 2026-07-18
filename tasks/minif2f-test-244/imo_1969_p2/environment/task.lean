import Mathlib

open scoped Nat
open scoped Real

/--
Let $f(x)=\cos(a_1+x)+{1\over2}\cos(a_2+x)+{1\over4}\cos(a_3+x)+\ldots+{1\over2^{n-1}}\cos(a_n+x)$, where $a_i$ are real constants and $x$ is a real variable. If $f(x_1)=f(x_2)=0$, prove that $x_1-x_2$ is a multiple of $\pi$.
-/
theorem imo_1969_p2 (m n : ℝ) (k : ℕ) (a : ℕ → ℝ) (y : ℝ → ℝ) (h₀ : 0 < k)
    (h₁ : ∀ x, y x = ∑ i ∈ Finset.range k, Real.cos (a i + x) / 2 ^ i) (h₂ : y m = 0)
    (h₃ : y n = 0) : ∃ t : ℤ, m - n = t * π := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
