import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)

theorem delete_len_eq {x: Nat} {xs: List Nat} (h: x ∈ xs): (deleteFirst x xs).length + 1 = xs.length := by sorry
