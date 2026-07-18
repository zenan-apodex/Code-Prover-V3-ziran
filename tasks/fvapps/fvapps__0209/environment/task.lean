import Mathlib

def List.sum (xs : List Nat) : Nat :=
  match xs with
  | [] => 0
  | x::xs => x + List.sum xs

def merge_stones (stones : List Nat) (k : Nat) : Int :=
  sorry

theorem merge_stones_impossible (stones : List Nat) (k : Nat)
  (h : (stones.length - 1) % (k - 1) ≠ 0) :
  merge_stones stones k = -1 :=
  sorry

theorem merge_stones_possible_nonneg (stones : List Nat) (k : Nat) 
  (h : (stones.length - 1) % (k - 1) = 0) :
  merge_stones stones k ≥ 0 :=
  sorry

theorem merge_stones_bounded (stones : List Nat) (k : Nat)
  (h : (stones.length - 1) % (k - 1) = 0) :
  ∃ bound : Nat, merge_stones stones k ≤ bound :=
  sorry

theorem merge_stones_single_stone (k : Nat) :
  merge_stones [1] k = 0 :=
  sorry

theorem merge_stones_two_stones :
  merge_stones [1,1] 2 = 2 :=
  sorry
