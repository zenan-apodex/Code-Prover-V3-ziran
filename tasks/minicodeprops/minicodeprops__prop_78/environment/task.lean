import Mathlib

def insort : Nat → List Nat → List Nat
  | n, [] => [n]
  | n, x::xs => if n <= x then n::x::xs else x::(insort n xs)


def sort : List Nat → List Nat
  | [] => []
  | x::xs => insort x (sort xs)


def sorted : List Nat → Bool
  | [] => True
  | [_x] => True
  | x::y::xs => and (x <= y) (sorted (y::xs))

theorem prop_78 (xs: List Nat) :
  sorted (sort xs):= by sorry
