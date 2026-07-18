import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $n$ and $k$ are positive integers such that $5<\frac nk< 6$, then what is the smallest possible value of $\frac{\mathop{\text{lcm}}[n,k]}{\gcd(n,k)}$? -/
theorem mathd_numbertheory_530 :
  IsLeast {t : ℕ | ∃ (n k : ℕ), 0 < n ∧ 0 < k ∧
    (n / k : ℚ) ∈ Set.Ioo 5 6 ∧ t = Nat.lcm n k / Nat.gcd n k} (22) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
