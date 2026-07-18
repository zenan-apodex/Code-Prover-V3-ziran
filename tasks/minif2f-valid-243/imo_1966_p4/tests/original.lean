import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Prove that for every natural number $n$, and for every real number $x \neq \frac{k\pi}{2^t}$ ($t=0,1, \dots, n$; $k$ any integer) \[ \frac{1}{\sin{2x}}+\frac{1}{\sin{4x}}+\dots+\frac{1}{\sin{2^nx}}=\cot{x}-\cot{2^nx}  \] -/
theorem imo_1966_p4 (n : ℕ) (x : ℝ) (h₀ : ∀ t : ℕ, t ≤ n → ∀ k : ℤ, x ≠ k * π / 2 ^ t)
    (h₁ : 0 < n) :
    ∑ i ∈ Finset.Icc 1 n, 1 / Real.sin (2 ^ i * x) = 1 / Real.tan x - 1 / Real.tan (2 ^ n * x) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
