import Mathlib

def twoThirds : Nat → Nat
| 0 => 0
| 1 => 0
| 2 => 0
| n + 3 => 2 + (twoThirds n)

theorem twon_lt' (n: Nat): twoThirds (n.succ.succ.succ) < n.succ.succ.succ := by sorry
