import Mathlib

def at' : List α → Nat → Option α
  | x::_, 0 => x
  | _::xs, n => at' xs (n - 1)
  | [], _ => none

theorem prop_elem (x: α) (xs: List α) [DecidableEq α] :
  x ∈ xs → ∃i, x == at' xs i:= by sorry
