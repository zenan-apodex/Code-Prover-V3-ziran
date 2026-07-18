import Mathlib

open scoped Nat
open scoped Real

/--
Prove that for any n natural, the number \[ \sum \limits_{k=0}^{n} \binom{2n+1}{2k+1} 2^{3k}  \]
cannot be divided by $5$.
-/
theorem imo_1974_p3 (n : ℕ) :
    ¬5 ∣ ∑ k ∈ Finset.range (n + 1), Nat.choose (2 * n + 1) (2 * k + 1) * 2 ^ (3 * k) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
