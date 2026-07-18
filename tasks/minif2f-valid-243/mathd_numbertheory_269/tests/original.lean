import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
When the expression $2005^2 + 2005^0 + 2005^0 + 2005^5$ is evaluated, what are the final two digits? -/
theorem mathd_numbertheory_269 : (2005 ^ 2 + 2005 ^ 0 + 2005 ^ 0 + 2005 ^ 5) % 100 = (52) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
