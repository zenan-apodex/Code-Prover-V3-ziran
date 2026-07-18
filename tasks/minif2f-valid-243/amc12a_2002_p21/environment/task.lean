import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Consider the sequence of numbers: $ 4, 7, 1, 8, 9, 7, 6, \ldots .$ For $ n > 2$, the $ n$th term of the sequence is the units digit of the sum of the two previous terms. Let $ S_n$ denote the sum of the first $ n$ terms of this sequence. The smallest value of $ n$ for which $ S_n > 10,000$ is:

$ \textbf{(A)}\ 1992 \qquad \textbf{(B)}\ 1999 \qquad \textbf{(C)}\ 2001 \qquad \textbf{(D)}\ 2002 \qquad \textbf{(E)}\ 2004$ -/
theorem amc12a_2002_p21 (u : ℕ → ℕ) (h₀ : u 0 = 4) (h₁ : u 1 = 7)
    (h₂ : ∀ n, u (n + 2) = (u n + u (n + 1)) % 10) :
    IsLeast {n : ℕ | ∑ k ∈ Finset.range n, u k > 10000} (1999) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
