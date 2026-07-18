import Mathlib

def half : Nat → Nat
| 0 => 0
| 1 => 0
| x + 2 => 1 + (half x)

theorem half_lt: half x ≤ x := by sorry
