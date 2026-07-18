import Mathlib

def insort : Nat → List Nat → List Nat
  | n, [] => [n]
  | n, x::xs => if n <= x then n::x::xs else x::(insort n xs)


def sort : List Nat → List Nat
  | [] => []
  | x::xs => insort x (sort xs)

theorem prop_53 (n: Nat) xs :
  (List.count n xs = List.count n (sort xs)):= by sorry
