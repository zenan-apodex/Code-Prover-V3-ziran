import Mathlib

def insort : Nat → List Nat → List Nat
  | n, [] => [n]
  | n, x::xs => if n <= x then n::x::xs else x::(insort n xs)


def sort : List Nat → List Nat
  | [] => []
  | x::xs => insort x (sort xs)

theorem prop_20 (xs: List Nat) :
  (List.length (sort xs) = List.length xs):= by sorry
