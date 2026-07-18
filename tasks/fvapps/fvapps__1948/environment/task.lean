import Mathlib

structure Point where
  x : Int
  y : Int
deriving DecidableEq

def numPoints (points : List Point) (r : Float) : Nat :=
  sorry

theorem numPoints_bounds {points : List Point} {r : Float} 
  (h1 : r > 0)
  (h2 : points ≠ []) :
  1 ≤ numPoints points r ∧ numPoints points r ≤ points.length :=
sorry

theorem numPoints_tiny_radius {points : List Point} 
  (h1 : points ≠ [])
  (h2 : r = 0.1) :
  numPoints points r = 1 :=
sorry

theorem numPoints_huge_radius {points : List Point}
  (h1 : points ≠ [])
  (h2 : r = 1000) :
  numPoints points r = points.length :=
sorry

theorem numPoints_shuffle {points perm : List Point} {r : Float}
  (h1 : r > 0)
  (h2 : perm.length = points.length)
  (h3 : ∀ p, p ∈ points ↔ p ∈ perm) :
  numPoints points r = numPoints perm r :=
sorry

theorem numPoints_single_point {r : Float}
  (h : r > 0) :
  numPoints [Point.mk 0 0] r = 1 :=
sorry

theorem numPoints_exact_radius :
  numPoints [Point.mk 0 0, Point.mk 2 0] 1 = 2 :=
sorry
