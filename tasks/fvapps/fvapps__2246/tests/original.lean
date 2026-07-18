import Mathlib

def min_cost_workout (n k : Nat) (x : List Nat) (a : Nat) (c : List Nat) : Int := sorry

def sum_list : List Nat → Nat 
  | [] => 0
  | h::t => h + sum_list t







theorem min_cost_workout_empty (k a : Nat) :
  min_cost_workout 0 k [] a [] = 0 := sorry
