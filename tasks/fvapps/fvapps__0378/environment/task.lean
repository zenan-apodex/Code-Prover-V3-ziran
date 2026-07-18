import Mathlib

def canPartition (nums : List Nat) : Bool := sorry

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + List.sum xs

theorem canPartition_returns_bool (nums : List Nat) :
  canPartition nums = true ∨ canPartition nums = false :=
sorry

theorem canPartition_odd_sum_false (nums : List Nat) :
  (List.sum nums % 2 ≠ 0) → canPartition nums = false :=
sorry 

theorem canPartition_same_nums_even_length (n : Nat) (len : Nat) :
  len % 2 = 0 →
  canPartition (List.replicate len n) = true :=
sorry

theorem canPartition_singleton_false (n : Nat) :
  canPartition [n] = false :=
sorry

theorem canPartition_pair_same_true (n : Nat) :
  canPartition [n, n] = true :=
sorry
