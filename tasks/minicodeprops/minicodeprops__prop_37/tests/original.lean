import Mathlib

def delete : Nat → List Nat → List Nat
  | _, [] => []
  | n, x::xs => if n == x then (delete n xs) else x::(delete n xs)

theorem prop_37 (x: Nat) (xs: List Nat) :
  not (x ∈ delete x xs):= by sorry
