import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the difference between the sum of the first $ 2003$ even counting numbers and the sum of the first $ 2003$ odd counting numbers?

$ \textbf{(A)}\ 0 \qquad
\textbf{(B)}\ 1 \qquad
\textbf{(C)}\ 2 \qquad
\textbf{(D)}\ 2003 \qquad
\textbf{(E)}\ 4006$ -/
theorem amc12a_2003_p1 (u v : ℕ → ℕ) (h₀ : ∀ n, u n = 2 * n + 2) (h₁ : ∀ n, v n = 2 * n + 1) :
    ∑ k ∈ Finset.range 2003, u k - ∑ k ∈ Finset.range 2003, v k = 2003 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
