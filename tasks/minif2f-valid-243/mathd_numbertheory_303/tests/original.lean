import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $n>1$ is an integer, the notation $a\equiv b\pmod{n}$ means that $(a-b)$ is a multiple of $n$. Find the sum of all possible values of $n$ such that both of the following are true: $171\equiv80\pmod{n}$ and $468\equiv13\pmod{n}$. -/
theorem mathd_numbertheory_303 (S : Finset ℕ)
    (h₀ : ∀ n : ℕ, n ∈ S ↔ 2 ≤ n ∧ 171 ≡ 80 [MOD n] ∧ 468 ≡ 13 [MOD n]) : ∑ k ∈ S, k = (111) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
