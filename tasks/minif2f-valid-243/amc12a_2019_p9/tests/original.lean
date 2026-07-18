import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- A sequence of numbers is defined recursively by $a_1 = 1$, $a_2 = \frac{3}{7}$, and
$$a_n=\frac{a_{n-2} \cdot a_{n-1}}{2a_{n-2} - a_{n-1}}$$for all $n \geq 3$ Then $a_{2019}$ can be written as $\frac{p}{q}$, where $p$ and $q$ are relatively prime positive integers. What is $p+q ?$

$\textbf{(A) } 2020 \qquad\textbf{(B) } 4039 \qquad\textbf{(C) } 6057 \qquad\textbf{(D) } 6061 \qquad\textbf{(E) } 8078$ -/
theorem amc12a_2019_p9 (a : ℕ → ℚ) (h₀ : a 1 = 1) (h₁ : a 2 = 3 / 7)
    (h₂ : ∀ n ≥ 3, a n = a (n - 2 : ℕ) * a (n - 1 : ℕ) / (2 * a (n - 2 : ℕ) - a (n - 1 : ℕ))) :
    ↑(a 2019).den + (a 2019).num = (8078) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
