import Mathlib

def h_index (citations : List Nat) : Nat :=
  sorry

theorem h_index_bounded_by_length {citations : List Nat} (h : citations ≠ []) :
  h_index citations ≤ citations.length :=
  sorry

theorem h_index_nonnegative (citations : List Nat) :
  h_index citations ≥ 0 :=
  sorry
