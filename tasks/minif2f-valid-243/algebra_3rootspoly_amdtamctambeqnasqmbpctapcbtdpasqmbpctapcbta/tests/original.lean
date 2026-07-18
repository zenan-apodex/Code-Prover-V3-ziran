import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $(a-d)(a-c)(a-b)$ is equal to -((a^2 - (b + c) a + c  b) d) + (a^2 - (b + c) a + c b) a. -/
theorem algebra_3rootspoly_amdtamctambeqnasqmbpctapcbtdpasqmbpctapcbta (b c d a : ℂ) :
    (a - d) * (a - c) * (a - b) =
      -((a ^ 2 - (b + c) * a + c * b) * d) + (a ^ 2 - (b + c) * a + c * b) * a := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
