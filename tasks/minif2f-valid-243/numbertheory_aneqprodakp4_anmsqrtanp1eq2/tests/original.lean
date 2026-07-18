import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $a_n$ be a sequence of real numbers with $a_1 = 1$, and $a_{n+1} = \prod_{k=1}^{n} a_n + 4$.
Show that $a_n - \sqrt{a_{n+1}} = 2$ for all $n > 1$. -/
--/
theorem numbertheory_aneqprodakp4_anmsqrtanp1eq2 (a : ℕ → ℝ) (h₀ : a 0 = 1)
    (h₁ : ∀ n, a (n + 1) = ∏ k ∈ Finset.range (n + 1), a k + 4) :
    ∀ n ≥ 1, a n - Real.sqrt (a (n + 1)) = 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
