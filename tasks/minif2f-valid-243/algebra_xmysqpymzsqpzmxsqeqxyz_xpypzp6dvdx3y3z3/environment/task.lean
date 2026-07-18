import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For any integers $x, y, z$ with $(x - y)^2 + (y - z)^2 + (z - x)^2 = xyz$, prove that $x + y + z + 6$ divides $x^3 + y^3 + z^3$. -/
theorem algebra_xmysqpymzsqpzmxsqeqxyz_xpypzp6dvdx3y3z3 (x y z : ℤ)
    (h₀ : (x - y) ^ 2 + (y - z) ^ 2 + (z - x) ^ 2 = x * y * z) :
    x + y + z + 6 ∣ x ^ 3 + y ^ 3 + z ^ 3 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
