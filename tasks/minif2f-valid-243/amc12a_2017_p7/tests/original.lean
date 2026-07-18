import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Define a function on the positive integers recursively by $f(1) = 2$, $f(n) = f(n-1) + 1$ if $n$ is even, and $f(n) = f(n-2) + 2$ if $n$ is odd and greater than $1$. What is $f(2017)$?

$\textbf{(A) } 2017 \qquad \textbf{(B) } 2018 \qquad \textbf{(C) } 4034 \qquad \textbf{(D) } 4035 \qquad \textbf{(E) } 4036$ -/
theorem amc12a_2017_p7 (f : ℕ → ℝ) (h₀ : f 1 = 2) (h₁ : ∀ n, 1 < n ∧ Even n → f n = f (n - 1 : ℕ) + 1)
    (h₂ : ∀ n, 1 < n ∧ Odd n → f n = f (n - 2 : ℕ) + 2) : f 2017 = (2018) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
