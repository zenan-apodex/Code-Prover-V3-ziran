import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + List.sum xs

def split_all_even_numbers (numbers: List Nat) (split_type: Nat) : List Nat :=
  sorry

theorem split_all_even_numbers_preserves_sum 
  (numbers: List Nat) (split_type: Nat) (h: split_type ≤ 3) :
  List.sum numbers = List.sum (split_all_even_numbers numbers split_type) :=
  sorry

theorem split_all_even_numbers_positive
  (numbers: List Nat) (split_type: Nat) (h1: split_type ≤ 3) (h2: ∀ n ∈ numbers, n > 0) : 
  ∀ n ∈ (split_all_even_numbers numbers split_type), n > 0 :=
  sorry

theorem split_all_even_numbers_preserves_odd
  (numbers: List Nat) (split_type: Nat) (h: split_type ≤ 3) :
  ∀ n ∈ numbers, n % 2 = 1 → n ∈ (split_all_even_numbers numbers split_type) :=
  sorry
