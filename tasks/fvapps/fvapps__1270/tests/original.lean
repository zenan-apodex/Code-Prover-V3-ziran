import Mathlib

def build_two_towers (n : Nat) (k : Nat) (heights : List Nat) : Int := sorry

/-- Single box twice the height of k always returns -1 -/
theorem single_tall_box_impossible (height : Nat) :
  build_two_towers 1 height [2 * height] = -1 := sorry

/-- Given a list of heights, building towers of minimum height is always possible -/
theorem min_height_possible (heights : List Nat) (h : heights.length ≥ 2) :
  let n := heights.length
  let k := heights.minimum?
  match k with
  | none => True 
  | some k => build_two_towers n k heights ≠ -1
  := sorry

/-- List elements in different order produce the same result -/
theorem permutation_preserves_result (heights1 heights2 : List Nat) 
    (h1 : heights1.length ≥ 2)
    (h2 : heights1.isPerm heights2) :
  let n := heights1.length
  let k := heights1.minimum?
  match k with
  | none => True
  | some k => build_two_towers n k heights1 = build_two_towers n k heights2
  := sorry
