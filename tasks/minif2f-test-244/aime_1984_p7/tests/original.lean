import Mathlib

open scoped Nat
open scoped Real

/--
The function $f$ is defined on the set of integers and satisfies \[ f(n)=\begin{cases} n-3 & \text{if } n\ge 1000 \\ f(f(n+5)) & \text{if } n< 1000\end{cases}  \] Find $f(84)$.
-/
theorem aime_1984_p7 (f : ℤ → ℤ) (h₀ : ∀ n, 1000 ≤ n → f n = n - 3)
    (h₁ : ∀ n, n < 1000 → f n = f (f (n + 5))) : f 84 = 997 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
