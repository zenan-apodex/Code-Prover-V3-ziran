import Mathlib

def rad_ladies (s : String) : String := sorry

theorem rad_ladies_name_preserved {s : String} (h : s ≠ "") :
  let result := rad_ladies (s ++ "!")
  (result.startsWith s) ∧ (result.endsWith "!") := sorry

theorem rad_ladies_idempotent (s : String) :
  rad_ladies (rad_ladies s) = rad_ladies s := sorry
