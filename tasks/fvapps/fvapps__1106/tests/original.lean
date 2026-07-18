import Mathlib

structure Group : Type where
mk ::
  size : Nat
  start : Nat 
  «end» : Nat
  value : Nat

def get_max_earnings (n l k : Nat) (groups : List (Nat × Nat × Nat × Nat)) : Nat :=
  sorry

def hash_state (groups : List Group) (i : Nat) : List Nat :=
  sorry

def optimize (groups : List Group) : List Group :=
  sorry

theorem get_max_earnings_nonnegative (n l k : Nat) (groups : List (Nat × Nat × Nat × Nat)) :
  get_max_earnings n l k groups ≥ 0 :=
sorry

theorem get_max_earnings_bounded (n l k : Nat) (groups : List (Nat × Nat × Nat × Nat)) 
  (h : groups.length > 0) :
  get_max_earnings n l k groups ≤ groups.foldr (fun g acc => g.2.2.2 + acc) 0 :=
sorry 

theorem hash_state_length (groups : List Group) (i : Nat) :
  (hash_state groups i).length = groups.length + 1 :=
sorry

theorem hash_state_last_elem (groups : List Group) (i : Nat) 
  (h : hash_state groups i ≠ []) :
  (hash_state groups i).getLast h = i :=
sorry

theorem hash_state_ordered (groups : List Group) (i : Nat) (j : Nat) 
  (h : j + 1 < (hash_state groups i).length) :
  ((hash_state groups i)[j] ≤ (hash_state groups i)[j+1]) :=
sorry

theorem optimize_ordered (groups : List Group) (j : Nat)
  (h : j + 1 < (optimize groups).length) :
  ((optimize groups)[j]).start ≤ ((optimize groups)[j+1]).start :=
sorry
