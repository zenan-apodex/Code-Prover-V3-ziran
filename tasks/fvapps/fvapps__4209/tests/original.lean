import Mathlib

def maximum : List Nat → Nat 
  | [] => 0
  | (x::xs) => max x (maximum xs)

def minimum : List Nat → Nat
  | [] => 0
  | (x::xs) => min x (minimum xs)

def largest_rect (heights : List Nat) : Nat :=
  sorry







theorem largest_rect_empty :
  largest_rect [] = 0 :=
  sorry
