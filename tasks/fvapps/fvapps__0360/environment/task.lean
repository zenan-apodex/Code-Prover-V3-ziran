import Mathlib

def List.sum : List Nat → Nat
  | [] => 0
  | x::xs => x + sum xs

def ship_within_days (weights : List Nat) (days : Nat) : Nat := sorry

theorem ship_within_days_one_day (weights : List Nat) 
  (h : weights ≠ []) :
  ship_within_days weights 1 = List.sum weights :=
  sorry

theorem ship_within_days_max_days (weights : List Nat)
  (h : weights ≠ []) :
  ship_within_days weights (List.length weights) ≥ (List.maximum? weights).getD 0 :=
  sorry

theorem ship_within_days_monotonic (weights : List Nat) 
  (d1 d2 : Nat)
  (h1 : List.length weights ≥ 2)
  (h2 : d1 ≤ d2) :
  ship_within_days weights d1 ≥ ship_within_days weights d2 :=
  sorry
