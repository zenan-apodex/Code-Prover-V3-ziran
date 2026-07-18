import Mathlib

def Coord := Nat × Nat 

def max_distinct_sum (n: Nat) (pairs: List Coord) : Nat :=
  sorry





def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + List.sum xs

theorem max_distinct_sum_single_coord (n: Nat) :
  max_distinct_sum n [(1,n)] = 0 :=
sorry
