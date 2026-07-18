import Mathlib

open scoped Nat
open scoped Real

/--
Let $ a_1, a_2, \ldots, a_{100}$ be nonnegative real numbers such that $ a^2_1 +{} a^2_2 +{} \ldots +{} a^2_{100} ={} 1.$ Prove that
\[ a^2_1 \cdot a_2 +{} a^2_2 \cdot a_3 +{} \ldots +{} a^2_{100} \cdot a_1 < \frac {12}{25}.
\]
[i]Author: Marcin Kuzma, Poland[/i]
-/
theorem imoshortlist_2007_algebra_p6 (a : ℕ → NNReal)
    (h₀ : ∑ x ∈ Finset.range 100, a (x + 1) ^ 2 = 1) :
    ∑ x ∈ Finset.range 99, a (x + 1) ^ 2 * a (x + 2) + a 100 ^ 2 * a 1 < 12 / 25 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
