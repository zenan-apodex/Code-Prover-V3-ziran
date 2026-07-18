import Mathlib

def min_score_triangulation (vertices : List Nat) : Nat := sorry

theorem min_score_triangulation_nonnegative (vertices : List Nat) 
  (h: vertices.length ≥ 3) : 
  min_score_triangulation vertices ≥ 0 := sorry

theorem min_score_triangulation_triangle (a b c : Nat) :
  min_score_triangulation [a, b, c] = a * b * c := sorry

theorem min_score_triangulation_cyclic_invariant (vertices : List Nat) 
  (h: vertices.length ≥ 3) :
  min_score_triangulation vertices = 
  min_score_triangulation (vertices.tail ++ [vertices.head!]) := sorry
