import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $ f$ be a function satisfying $ f(xy) ={} f(x)/y$ for all positive real numbers $ x$ and $ y$. If $ f(500) ={} 3$, what is the value of $ f(600)$?

$ \textbf{(A)} \ 1 \qquad \textbf{(B)} \ 2 \qquad \textbf{(C)} \ \displaystyle \frac {5}{2} \qquad \textbf{(D)} \ 3 \qquad \textbf{(E)} \ \displaystyle \frac {18}{5}$ -/
theorem amc12_2001_p9 (f : ℝ → ℝ) (h₀ : ∀ x > 0, ∀ y > 0, f (x * y) = f x / y) (h₁ : f 500 = 3) :
    f 600 = (5 / 2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
