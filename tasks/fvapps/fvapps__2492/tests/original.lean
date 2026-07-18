import Mathlib

def min_operations (logs : List String) : Nat := sorry

theorem depth_never_negative (logs : List String) : 
  min_operations logs ≥ 0 := sorry

theorem up_directory_at_root (logs : List String) :
  min_operations ("../" :: logs) = min_operations logs := sorry

theorem current_directory_neutral (logs : List String) :
  min_operations logs = min_operations (logs ++ ["./"])  := sorry
