import Mathlib

/-- Represents a valid word for numbers 0-20 -/
inductive NumberWord where
  | zero | one | two | three | four | five | six | seven
  | eight | nine | ten | eleven | twelve | thirteen
  | fourteen | fifteen | sixteen | seventeen | eighteen
  | nineteen | twenty
  deriving Repr

/-- Calculates wallpaper rolls needed given room dimensions -/
def wallpaper (l w h : Float) : NumberWord := sorry

/-- If either width or length is 0, result is zero -/
theorem wallpaper_zero {l w h : Float} :
  l * w = 0 → wallpaper l w h = NumberWord.zero := sorry

/-- Result is always a valid number word between 0 and 20 -/
theorem wallpaper_valid_output {l w h : Float} :
  ∃ n : NumberWord, wallpaper l w h = n := sorry

/-- Non-negative inputs result in non-negative outputs -/
theorem wallpaper_nonneg {l w h : Float} :
  l ≥ 0 → w ≥ 0 → h ≥ 0 → 
  ∃ n : NumberWord, wallpaper l w h = n := sorry
