import Mathlib

structure Point where
  coord : Int × Int
  color : String
deriving Repr

structure TriangleCount where
  totalPoints : Nat
  uniqueColors : Nat  
  triangleCount : Nat
  maxColorInfo : Option (List String × Nat)
deriving Repr

def count_col_triang (points : List Point) : TriangleCount :=
sorry

theorem count_col_triang_basic_properties {points : List Point} :
  let result := count_col_triang points;
  result.totalPoints = points.length ∧ 
  result.uniqueColors ≤ result.totalPoints ∧
  result.triangleCount ≥ 0 := by sorry

theorem count_col_triang_max_info {points : List Point} :
  let result := count_col_triang points;
  (result.maxColorInfo = none → result.triangleCount = 0) ∧
  (result.maxColorInfo.isSome → 
    match result.maxColorInfo with
    | some (colors, count) => count > 0 ∧ colors.eraseDups = colors
    | none => True) := by sorry 

theorem count_col_triang_vertical_collinear {points : List Point} 
    (h : ∀ p ∈ points, p.coord.1 = 1) :
  let result := count_col_triang points;
  result.triangleCount = 0 ∧ result.maxColorInfo = none := by sorry

theorem count_col_triang_horizontal_collinear {points : List Point}
    (h : ∀ p ∈ points, p.coord.2 = 1) :
  let result := count_col_triang points;
  result.triangleCount = 0 ∧ result.maxColorInfo = none := by sorry
