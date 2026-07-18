import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Determine the smallest non-negative integer $a$ that satisfies the congruences: \begin{align*}
&a\equiv 2\pmod 3,\\
&a\equiv 4\pmod 5,\\
&a\equiv 6\pmod 7,\\
&a\equiv 8\pmod 9.
\end{align*} -/
theorem mathd_numbertheory_690 :
    IsLeast {a : ℕ | 0 < a ∧ a ≡ 2 [MOD 3] ∧ a ≡ 4 [MOD 5] ∧ a ≡ 6 [MOD 7] ∧ a ≡ 8 [MOD 9]} (314) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
