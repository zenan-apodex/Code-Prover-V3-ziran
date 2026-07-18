import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $$z=\frac{1+i}{\sqrt{2}}.$$ What is $$(z^{1^2}+z^{2^2}+z^{3^2}+\dots+z^{{12}^2}) \cdot (\frac{1}{z^{1^2}}+\frac{1}{z^{2^2}}+\frac{1}{z^{3^2}}+\dots+\frac{1}{z^{{12}^2}})?$$

$\textbf{(A) } 18 \qquad \textbf{(B) } 72-36\sqrt2 \qquad \textbf{(C) } 36 \qquad \textbf{(D) } 72 \qquad \textbf{(E) } 72+36\sqrt2$ -/
theorem amc12a_2019_p21 (z : ℂ) (h₀ : z = (1 + Complex.I) / Real.sqrt 2) :
    (∑ k ∈ Finset.Icc 1 12, z ^ k ^ 2) * ∑ k ∈ Finset.Icc 1 12, 1 / z ^ k ^ 2 = (36) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
