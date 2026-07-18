import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For what value of $ n$ is $ i+{}2i^2+{}3i^3+{}\cdots+{}ni^n={}48+{}49i$?

Note: here $ i={}\sqrt{-{}1}$.

$ \textbf{(A)}\ 24 \qquad
\textbf{(B)}\ 48 \qquad
\textbf{(C)}\ 49 \qquad
\textbf{(D)}\ 97 \qquad
\textbf{(E)}\ 98$ -/
theorem amc12a_2009_p15 (n : ℕ) (h₀ : 0 < n)
    (h₁ : ∑ k ∈ Finset.Icc 1 n, ↑k * Complex.I ^ k = 48 + 49 * Complex.I) : n = (97) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
