import Mathlib

def third : Nat → Nat
| 0 => 0
| 1 => 0
| 2 => 0
| n + 3 => 1 + (third n)

theorem third_eq_div_3 : (x/3) = third x := by sorry
