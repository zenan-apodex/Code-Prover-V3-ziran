import Mathlib

def who_is_winner (moves : List String) : String :=
  sorry

theorem valid_result_states (moves : List String) :
  let result := who_is_winner moves
  result = "Red" ∨ result = "Yellow" ∨ result = "Draw" := by
  sorry

def columnHeight (moves : List String) (col : String) : Nat :=
  sorry

theorem column_height_bound (moves : List String) (col : String) :
  columnHeight moves col ≤ 6 := by
  sorry
