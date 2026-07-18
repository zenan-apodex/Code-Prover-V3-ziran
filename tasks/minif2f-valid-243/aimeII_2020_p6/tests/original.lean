import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Define a sequence recursively by $t_1 = 20$, $t_2 = 21$, and$$t_n = \frac{5t_{n-1}+1}{25t_{n-2}}$$for all $n \ge 3$. Then $t_{2020}$ can be written as $\frac{p}{q}$, where $p$ and $q$ are relatively prime positive integers. Find $p+q$. -/
theorem aimeII_2020_p6 (t : ℕ → ℚ) (h₀ : t 1 = 20) (h₁ : t 2 = 21)
    (h₂ : ∀ n ≥ 3, t n = (5 * t (n - 1 : ℕ) + 1) / (25 * t (n - 2 : ℕ))) :
    ↑(t 2020).den + (t 2020).num = (626) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
