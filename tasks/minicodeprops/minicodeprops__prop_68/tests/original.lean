import Mathlib

def delete : Nat → List Nat → List Nat
  | _, [] => []
  | n, x::xs => if n == x then (delete n xs) else x::(delete n xs)

theorem prop_68 (n: Nat) (xs: List Nat) :
  List.length (delete n xs) <= List.length xs:= by sorry
