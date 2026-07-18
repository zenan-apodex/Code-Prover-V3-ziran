import Mathlib

open scoped Nat
open scoped Real

/--
For every real number $x_1$, construct the sequence $x_1,x_2,\ldots$ by setting: \[ x_{n+1}=x_n(x_n+{1\over n}). \] Prove that there exists exactly one value of $x_1$ which gives $0< x_n< x_{n+1}< 1$ for all $n$.
-/
theorem imo_1985_p6 (f : ℕ → NNReal → ℝ) (h₀ : ∀ x, f 1 x = x)
    (h₁ : ∀ x n, f (n + 1) x = f n x * (f n x + 1 / n)) :
    ∃! a, ∀ n, 0 < n → 0 < f n a ∧ f n a < f (n + 1) a ∧ f (n + 1) a < 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
