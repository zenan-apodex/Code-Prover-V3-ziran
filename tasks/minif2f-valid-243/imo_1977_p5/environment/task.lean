import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $a,b$ be two natural numbers. When we divide $a^2+b^2$ by $a+b$, we the the remainder $r$ and the quotient $q.$ Determine all pairs $(a, b)$ for which $q^2 + r = 1977.$ -/
theorem imo_1977_p5 :
  {(a, b) | (a : ℕ) (b : ℕ) (q : ℕ) (r : ℕ)
    (h₀ : r < a + b)
    (h₁ : a^2 + b^2 = (a + b) * q + r)
    (h₂ : q^2 + r = 1977)} =
    ({(37, 50), (7, 50), (50, 37), (50, 7)}) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
