import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $p$ and $q$ are natural numbers so that \[ \frac{p}{q}=1-\frac{1}{2}+\frac{1}{3}-\frac{1}{4}+ \ldots -\frac{1}{1318}+\frac{1}{1319}, \] prove that $p$ is divisible with $1979$. -/
theorem imo_1979_p1 (p q : ℕ) (h₀ : 0 < q)
    (h₁ : ∑ k ∈ Finset.Icc (1 : ℕ) 1319, (-1) ^ (k + 1) * ((1 : ℝ) / k) = p / q) : 1979 ∣ p := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
