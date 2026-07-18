import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For positive $x$, show that $2 - x - \frac{1}{2x}$ is at most $2 - \sqrt{2}$. -/
theorem algebra_amgm_faxinrrp2msqrt2geq2mxm1div2x :
    ∀ x > 0, 2 - Real.sqrt 2 ≥ 2 - x - 1 / (2 * x) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
