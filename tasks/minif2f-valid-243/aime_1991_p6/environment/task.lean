import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose $r$ is a real number for which \[ \left\lfloor r + \frac{19}{100} \right\rfloor + \left\lfloor r + \frac{20}{100} \right\rfloor + \left\lfloor r + \frac{21}{100} \right\rfloor + \cdots + \left\lfloor r + \frac{91}{100} \right\rfloor = 546.  \] Find $\lfloor 100r \rfloor$. (For real $x$, $\lfloor x \rfloor$ is the greatest integer less than or equal to $x$.) -/
theorem aime_1991_p6 (r : ℝ) (h₀ : ∑ k ∈ Finset.Icc (19 : ℕ) 91, Int.floor (r + k / 100) = 546) :
    Int.floor (100 * r) = (743) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
