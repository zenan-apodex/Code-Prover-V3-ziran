import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $ \sqrt{x+\!\sqrt{x+\!\sqrt{x+\!\sqrt{x+\cdots}}}}=9$, find $x$. -/
theorem mathd_algebra_31 (x : NNReal) (u : ℕ → NNReal) (h₀ : ∀ n, u (n + 1) = NNReal.sqrt (x + u n))
    (h₁ : Filter.Tendsto u Filter.atTop (𝓝 9)) : 9 = NNReal.sqrt (x + 9) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
