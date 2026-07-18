import Mathlib

def insort : Nat → List Nat → List Nat
  | n, [] => [n]
  | n, x::xs => if n <= x then n::x::xs else x::(insort n xs)


def sorted : List Nat → Bool
  | [] => True
  | [_x] => True
  | x::y::xs => and (x <= y) (sorted (y::xs))

theorem prop_77 (x: Nat) (xs: List Nat) :
  sorted xs → sorted (insort x xs):= by sorry
