import Mathlib

structure Point where
  x : Float
  y : Float
deriving Repr

def vectorLength (p1 p2 : Point) : Float := 
  sorry

theorem vectorLength_nonnegative (p1 p2 : Point) :
  vectorLength p1 p2 ≥ 0 := by
  sorry

theorem vectorLength_symmetric (p1 p2 : Point) :
  vectorLength p1 p2 = vectorLength p2 p1 := by
  sorry

theorem vectorLength_same_point (p : Point) :
  vectorLength p p = 0 := by
  sorry

theorem vectorLength_triangle_inequality (a b c : Point) :
  vectorLength a c ≤ vectorLength a b + vectorLength b c := by
  sorry
