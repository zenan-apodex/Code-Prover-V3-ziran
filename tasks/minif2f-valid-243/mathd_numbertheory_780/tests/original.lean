import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose $m$ is a two-digit positive integer such that $6^{-1}\pmod m$ exists and $6^{-1}\equiv 6^2\pmod m$. What is $m$? -/
theorem mathd_numbertheory_780 (m x : ℤ) (h₀ : 10 ≤ m) (h₁ : m ≤ 99) (h₂ : 6 * x % m = 1)
    (h₃ : (x - 6 ^ 2) % m = 0) : m = (43) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
