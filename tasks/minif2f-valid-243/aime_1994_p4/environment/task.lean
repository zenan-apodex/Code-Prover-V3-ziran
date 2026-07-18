import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Find the positive integer $n$ for which \[ \lfloor \log_2{1}\rfloor+\lfloor\log_2{2}\rfloor+\lfloor\log_2{3}\rfloor+\cdots+\lfloor\log_2{n}\rfloor=1994.  \]  (For real $x$, $\lfloor x\rfloor$ is the greatest integer $\le x.$) -/
theorem aime_1994_p4 (n : ℕ) (h₀ : n > 0) (h₁ : ∑ k ∈ Finset.Icc 1 n, Int.floor (Real.logb 2 k) = 1994) :
    n = (312) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
