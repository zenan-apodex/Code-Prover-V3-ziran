import Mathlib

def ins: Nat → List Nat → List Nat
  | n, []  =>  [n]
  | n, x::xs => if (n < x) then n :: x :: xs else x :: (ins n xs)

theorem prop_86 (x: Nat) (y: Nat) (xs: List Nat) :
  x < y → ((x ∈ (ins y xs)) == (x ∈ xs)):= by sorry
