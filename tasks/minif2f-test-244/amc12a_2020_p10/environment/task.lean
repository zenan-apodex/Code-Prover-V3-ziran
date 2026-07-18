import Mathlib

open scoped Nat
open scoped Real

/--
There is a unique positive integer $n$ larger than 1 such that \[\log_2{(\log_{16}{n})} = \log_4{(\log_4{n})}.\]
What is the sum of the digits of $n?$

$\textbf{(A) } 4 \qquad \textbf{(B) } 7 \qquad \textbf{(C) } 8 \qquad \textbf{(D) } 11 \qquad \textbf{(E) } 13$
-/
theorem amc12a_2020_p10 (n : ℕ) (h₀ : 1 < n)
    (h₁ : Real.logb 2 (Real.logb 16 n) = Real.logb 4 (Real.logb 4 n)) :
    (Nat.digits 10 n).sum = 13 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
