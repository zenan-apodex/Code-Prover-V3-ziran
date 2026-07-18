import Mathlib

def ins: Nat → List Nat → List Nat
  | n, []  =>  [n]
  | n, x::xs => if (n < x) then n :: x :: xs else x :: (ins n xs)

theorem prop_15 (x: Nat) (xs: List Nat) :
  (List.length (ins x xs)) = (List.length xs).succ:= by sorry
