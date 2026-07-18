import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $u_i$ be a sequence of natural numbers with $u_1 = 0$ and $u_{n+1} = 2 u_n + n$. Show that $u_n = 2^n - (n+1)$ for all $n$. -/
theorem induction_seq_mul2pnp1 (n : ℕ) (u : ℕ → ℕ) (h₀ : u 0 = 0)
    (h₁ : ∀ n, u (n + 1) = 2 * u n + (n + 1)) : u n = 2 ^ (n + 1) - (n + 2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
