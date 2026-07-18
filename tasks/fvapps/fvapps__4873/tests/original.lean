import Mathlib

structure Point where
  x : Float
  y : Float
  z : Float
deriving Repr

def distance_between_points (p1 p2 : Point) : Float :=
  sorry

theorem distance_symmetric (p1 p2 : Point) :
  distance_between_points p1 p2 = distance_between_points p2 p1 :=
  sorry

theorem distance_to_self (p : Point) :
  distance_between_points p p = 0 :=
  sorry

theorem triangle_inequality (p1 p2 p3 : Point) :
  distance_between_points p1 p3 ≤ 
  distance_between_points p1 p2 + distance_between_points p2 p3 :=
  sorry

theorem distance_matches_formula (p1 p2 : Point) :
  distance_between_points p1 p2 = 
  Float.sqrt ((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2) :=
  sorry
