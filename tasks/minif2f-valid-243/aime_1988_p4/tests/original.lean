import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Suppose that $|x_i| < 1$ for $i = 1, 2, \dots, n$.  Suppose further that
\[ |x_1| + |x_2| + \dots + |x_n| = 19 + |x_1 + x_2 + \dots + x_n|. \]
What is the smallest possible value of $n$? -/
theorem aime_1988_p4 :
    IsLeast {n : ℕ | ∃ a : Fin n → ℝ, (∀ n, abs (a n) < 1) ∧
      ∑ k, abs (a k) = 19 + abs (∑ k, a k)}
    (20) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
