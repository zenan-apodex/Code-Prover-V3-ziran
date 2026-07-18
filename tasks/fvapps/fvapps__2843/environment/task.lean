import Mathlib

def List.sum : List Nat → Nat
  | [] => 0
  | x::xs => x + sum xs

def List.minimum : List Nat → Nat
  | [] => 0 
  | [x] => x
  | x::xs => Nat.min x (minimum xs)

def pack_bagpack (scores weights : List Nat) (capacity : Nat) : Nat :=
  sorry

theorem pack_backpack_non_negative (scores weights : List Nat) (capacity : Nat) :
  pack_bagpack scores weights capacity ≥ 0 := sorry

theorem pack_backpack_at_most_sum_scores (scores weights : List Nat) (capacity : Nat) :
  pack_bagpack scores weights capacity ≤ List.sum scores := sorry

theorem pack_backpack_zero_if_capacity_too_small 
  (scores weights : List Nat) (capacity : Nat)
  (h : capacity < List.minimum weights) :
  pack_bagpack scores weights capacity = 0 := sorry

def max_valid_score (scores weights : List Nat) (capacity : Nat) : Nat :=
  let pairs := List.zip scores weights
  let valid := List.filter (fun p => p.snd ≤ capacity) pairs
  let scores := List.map Prod.fst valid
  match scores with
  | [] => 0
  | x::xs => List.foldl Nat.max x xs

theorem pack_backpack_at_least_max_valid_score 
  (scores weights : List Nat) (capacity : Nat)
  (h : scores.length = weights.length)
  (h2 : scores.length > 0) :
  pack_bagpack scores weights capacity ≥ max_valid_score scores weights capacity := sorry
