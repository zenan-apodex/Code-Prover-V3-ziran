import Mathlib

def filter : List Nat → (Nat → Bool) → List Nat
| [], _f => []
| x::xs, f => if f x then x::(filter xs f) else (filter xs f)

theorem filter_len_le {f: Nat → Bool} {xs: List Nat}: (filter xs f).length <= xs.length := by sorry
