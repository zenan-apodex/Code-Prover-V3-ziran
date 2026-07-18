import Mathlib

structure Share where
  id: Nat
  value: Nat

def find_max_shares_to_sell (shares: List Share) : Nat :=
  sorry

def is_unique_shares (shares: List Share) : Bool :=
  sorry

def is_strictly_increasing (l: List Nat) : Bool :=
  match l with
  | [] => true
  | [_] => true
  | x :: y :: xs => x < y && is_strictly_increasing (y :: xs)

def is_strictly_decreasing (l: List Nat) : Bool :=
  match l with
  | [] => true
  | [_] => true
  | x :: y :: xs => x > y && is_strictly_decreasing (y :: xs)

def sorted_shares (shares: List Share) : List Share :=
  sorry

theorem max_shares_bounds {shares: List Share} (h: shares ≠ []) :
  1 ≤ find_max_shares_to_sell shares ∧ find_max_shares_to_sell shares ≤ shares.length :=
sorry

theorem max_shares_sort_invariant (shares: List Share) :
  find_max_shares_to_sell shares = find_max_shares_to_sell (sorted_shares shares) :=
sorry

theorem strictly_increasing_max_shares {shares: List Share} (h1: shares ≠ []) 
  (h2: is_strictly_increasing (shares.map Share.value)) :
  find_max_shares_to_sell (sorted_shares shares) = shares.length :=
sorry

theorem strictly_decreasing_max_shares {shares: List Share} (h1: shares ≠ [])
  (h2: is_strictly_decreasing (shares.map Share.value)) :
  find_max_shares_to_sell (sorted_shares shares) = 1 :=
sorry
