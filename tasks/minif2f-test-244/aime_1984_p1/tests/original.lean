import Mathlib

open scoped Nat
open scoped Real

/--
Find the value of $a_2 + a_4 + a_6 + \dots + a_{98}$ if $a_1$, $a_2$, $a_3$, $\dots$ is an arithmetic progression with common difference 1, and $a_1 + a_2 + a_3 + \dots + a_{98} = 137$.
-/
theorem aime_1984_p1 (u : ℕ → ℚ) (h₀ : ∀ n, u (n + 1) = u n + 1)
    (h₁ : ∑ k ∈ Finset.range 98, u k.succ = 137) : ∑ k ∈ Finset.range 49, u (2 * k.succ) = 93 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
