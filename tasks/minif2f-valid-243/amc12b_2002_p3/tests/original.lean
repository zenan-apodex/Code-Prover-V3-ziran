import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For how many positive integers $ n$ is $ n^2-{}3n+{}2$ a prime number?

$ \textbf{(A)}\ \text{none} \qquad
\textbf{(B)}\ \text{one} \qquad
\textbf{(C)}\ \text{two} \qquad
\textbf{(D)}\ \text{more than two, but finitely many}\\
\textbf{(E)}\ \text{infinitely many}$ -/
theorem amc12b_2002_p3 (S : Finset ℕ)
    -- note: we use (n^2 + 2 - 3 * n) over (n^2 - 3 * n + 2) because nat subtraction truncates the latter at 1 and 2
    (h₀ : ∀ n : ℕ, n ∈ S ↔ 0 < n ∧ Nat.Prime (n ^ 2 + 2 - 3 * n)) :
    S.card = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
