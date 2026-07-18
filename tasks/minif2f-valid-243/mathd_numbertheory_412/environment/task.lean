import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $x \equiv 4 \pmod{19}$ and $y \equiv 7 \pmod{19}$, then find the remainder when $(x + 1)^2 (y + 5)^3$ is divided by 19. -/
theorem mathd_numbertheory_412 (x y : ℕ) (h₀ : x % 19 = 4) (h₁ : y % 19 = 7) :
    (x + 1) ^ 2 * (y + 5) ^ 3 % 19 = (13) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
