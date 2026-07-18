import Mathlib

def min_cost_to_move_chips (positions: List Nat) : Nat :=
sorry

def count_even (positions: List Nat) : Nat :=
sorry

theorem min_cost_upper_bound (positions: List Nat) (h: positions ≠ []) :
  min_cost_to_move_chips positions ≤ positions.length :=
sorry

theorem min_cost_non_negative (positions: List Nat) :
  min_cost_to_move_chips positions ≥ 0 :=
sorry
