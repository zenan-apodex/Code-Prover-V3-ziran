import Mathlib

def ins: Nat → List Nat → List Nat
  | n, []  =>  [n]
  | n, x::xs => if (n < x) then n :: x :: xs else x :: (ins n xs)

theorem prop_30 (x: Nat) (xs: List Nat) :
  x ∈ ins x xs:= by sorry
