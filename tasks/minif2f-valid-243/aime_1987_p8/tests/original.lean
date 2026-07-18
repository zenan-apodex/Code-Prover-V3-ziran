import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the largest positive integer $n$ for which there is a unique integer $k$ such that $\frac{8}{15} < \frac{n}{n + k} < \frac{7}{13}$? -/
theorem aime_1987_p8 :
    IsGreatest {n : ℕ | 0 < n ∧ ∃! k : ℤ, (8 : ℝ) / 15 < n / (n + k) ∧ (n : ℝ) / (n + k) < 7 / 13}
      (112) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
