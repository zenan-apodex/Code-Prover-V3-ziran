import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
There are integers $a$, $b$, and $c$, each greater than 1, such that $$\sqrt[a]{N \sqrt[b]{N \sqrt[c]{N}}} = \sqrt[36]{N^{25}}$$ for all $N > 1$. What is $b$?

$\textbf{(A)}\ 2\qquad\textbf{(B)}\ 3\qquad\textbf{(C)}\ 4\qquad\textbf{(D)}\ 5\qquad\textbf{(E)}\ 6$ -/
theorem amc12a_2020_p13 (a b c : ℕ) (n : ℝ)
    -- With h₀: 1 < n, ℝ should be fine over nnreal.
    (h₀ : 1 < n)
    (h₁ : 1 < a ∧ 1 < b ∧ 1 < c)
    (h₂ : (n * (n * n ^ (1 / c : ℝ)) ^ (1 / b : ℝ)) ^ (1 / a : ℝ) = (n ^ 25) ^ (1 / 36 : ℝ)) :
    b = (3) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
