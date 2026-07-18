import Mathlib

def Point := Prod Int Int 

def min_area_rectangle (points : List Point) : Nat := sorry 

theorem min_area_rectangle_nonnegative (points : List Point) : 
  min_area_rectangle points ≥ 0 := sorry

theorem min_area_rectangle_small_lists (points : List Point) : 
  points.length < 4 → min_area_rectangle points = 0 := sorry

theorem min_area_rectangle_single_line (points : List Point) :
  (∀ (p1 p2 : Point), p1 ∈ points → p2 ∈ points → p1.1 = p2.1) ∨ 
  (∀ (p1 p2 : Point), p1 ∈ points → p2 ∈ points → p1.2 = p2.2) →
  min_area_rectangle points = 0 := sorry

theorem min_area_rectangle_bound (points : List Point) 
  (h : points.length ≥ 4)
  (h2 : min_area_rectangle points > 0) :
  let xs := points.map Prod.fst;
  let ys := points.map Prod.snd;
  let max_x := xs.maximum? |>.getD 0;
  let min_x := xs.minimum? |>.getD 0;
  let max_y := ys.maximum? |>.getD 0;
  let min_y := ys.minimum? |>.getD 0;
  min_area_rectangle points ≤ (max_x - min_x) * (max_y - min_y) := sorry

theorem min_area_rectangle_translation_invariant (points : List Point) (shift : Int) :
  min_area_rectangle points = 
  min_area_rectangle (points.map fun p => (p.1 + shift, p.2 + shift)) := sorry
