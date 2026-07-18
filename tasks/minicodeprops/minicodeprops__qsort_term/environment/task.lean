import Mathlib

def filter : List Nat → (Nat → Bool) → List Nat
| [], _f => []
| x::xs, f => if f x then x::(filter xs f) else (filter xs f)

theorem qsort_term (x:Nat) (xs: List Nat) : List.length (filter xs fun y => decide (y ≤ x)) < Nat.succ (List.length xs) := by sorry
