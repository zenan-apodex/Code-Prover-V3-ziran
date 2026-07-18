import Mathlib

def Direction := String
def elevator (left right call : Int) : Direction :=
  sorry

theorem elevator_returns_valid_result 
  (left right call : Int) :
  (elevator left right call = "left") ∨ (elevator left right call = "right") :=
sorry

theorem elevator_nearest_to_call
  (left right call : Int) :
  let left_dist := Int.natAbs (call - left)
  let right_dist := Int.natAbs (call - right)
  (left_dist < right_dist → elevator left right call = "left") ∧
  (left_dist ≥ right_dist → elevator left right call = "right") :=
sorry

theorem elevator_equal_distance
  (pos call : Int) :
  elevator pos pos call = "right" :=
sorry
