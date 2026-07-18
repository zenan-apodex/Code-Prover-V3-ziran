import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (h::t) => h + sum t

def solve_min_cost_trip (n m a b c : Nat) (prices : List Nat) (edges : List (Nat × Nat)) : Nat :=
sorry

theorem solve_min_cost_trip_non_negative (n m a b c : Nat) (prices : List Nat) 
    (edges : List (Nat × Nat)) : 
    solve_min_cost_trip n m a b c prices edges ≥ 0 :=
sorry

theorem solve_min_cost_trip_bounded (n m a b c : Nat) (prices : List Nat)
    (edges : List (Nat × Nat)) :
    solve_min_cost_trip n m a b c prices edges ≤ 
    (List.take m prices).sum :=
sorry
