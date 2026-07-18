import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
How many positive integers $n$ are there such that $n$ is a multiple of $5$, and the least common multiple of $5!$ and $n$ equals $5$ times the greatest common divisor of $10!$ and $n?$

$\textbf{(A) } 12 \qquad \textbf{(B) } 24 \qquad \textbf{(C) } 36 \qquad \textbf{(D) } 48 \qquad \textbf{(E) } 72$ -/
theorem amc12a_2020_p21 (S : Finset ℕ)
    (h₀ : ∀ n : ℕ, n ∈ S ↔ 5 ∣ n ∧ Nat.lcm 5! n = 5 * Nat.gcd 10! n) : S.card = (48) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
