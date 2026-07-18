import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $ f$ be a function for which $ f(x/3) ={} x^2 +{} x +{} 1$. Find the sum of all values of $ z$ for which $ f(3z) ={} 7$.

$ \textbf{(A)}\ -{} 1/3 \qquad \textbf{(B)}\ -{} 1/9 \qquad \textbf{(C)}\ 0 \qquad \textbf{(D)}\ 5/9 \qquad \textbf{(E)}\ 5/3$ -/
theorem amc12_2000_p15 (f : ℂ → ℂ) (h₀ : ∀ x, f (x / 3) = x ^ 2 + x + 1)
    (h₁ : Fintype (f ⁻¹' {7})) : ∑ y ∈ (f ⁻¹' {7}).toFinset, y / 3 = (-1 / 9) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
