import Mathlib

def add_all (lst: List Nat) : Nat :=
  sorry

theorem add_all_non_negative (lst: List Nat) (h: lst ≠ []) :
  add_all lst ≥ 0 :=
  sorry

theorem add_all_preserves_input (lst: List Nat) (h: lst ≠ []) :
  let lst' := lst
  add_all lst = add_all lst' ∧ lst = lst' :=
  sorry

theorem add_all_larger_than_pairwise (lst: List Nat) (h: lst.length ≥ 2) :
  ∀ i j, i < j → j < lst.length →
    add_all lst ≥ lst[i]! + lst[j]! :=
  sorry

theorem add_all_singleton (lst: List Nat) (h: lst.length = 1) :
  add_all lst = 0 :=
  sorry
