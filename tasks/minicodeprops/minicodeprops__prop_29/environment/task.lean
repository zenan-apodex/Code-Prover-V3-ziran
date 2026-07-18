import Mathlib

def ins1 : Nat → List Nat → List Nat
  | n, [] => [n]
  | n, x::xs => if n == x then x::xs else x::(ins1 n xs)

theorem prop_29 (x: Nat) (xs: List Nat) :
  x ∈ ins1 x xs:= by sorry
