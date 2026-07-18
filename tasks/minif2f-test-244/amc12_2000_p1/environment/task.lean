import Mathlib

open scoped Nat
open scoped Real

/--
In the year $ 2001$, the United States will host the International Mathematical Olympiad. Let $ I$, $ M$, and $ O$ be distinct positive integers such that the product $ I\cdot M \cdot O ={} 2001$. What's the largest possible value of the sum $ I +{} M +{} O$?

$ \textbf{(A)}\  23 \qquad \textbf{(B)}\ 55 \qquad \textbf{(C)}\  99 \qquad \textbf{(D)}\  111 \qquad \textbf{(E)}\ 671$
-/
theorem amc12_2000_p1 :
    IsGreatest
      { i + m + o |
        (i : ℕ) (m : ℕ) (o : ℕ)
        (h₀ : i ≠ 0 ∧ m ≠ 0 ∧ o ≠ 0 ∧ i ≠ m ∧ i ≠ o ∧ m ≠ o)
        (h₁ : i*m*o = 2001)}
      671 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
