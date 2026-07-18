import Mathlib

structure Rectangle where
  x1 : Int
  y1 : Int
  x2 : Int
  y2 : Int

def is_rectangles_overlap (r1 r2 : Rectangle) : Bool :=
  sorry

theorem overlap_symmetric {r1 r2 : Rectangle} :
  is_rectangles_overlap r1 r2 = is_rectangles_overlap r2 r1 := by
  sorry

theorem self_overlap {r : Rectangle} :
  is_rectangles_overlap r r = true := by
  sorry

theorem far_apart_no_overlap {r1 : Rectangle} {w h : Int}
  (hw : w > 0) (hh : h > 0) :
  let r2 := Rectangle.mk (r1.x2 + 1) (r1.y2 + 1) (r1.x2 + 2) (r1.y2 + 2)
  is_rectangles_overlap r1 r2 = false := by
  sorry

theorem touching_right_no_overlap {x y w h : Int}
  (hw : w > 0) (hh : h > 0) : 
  let r1 := Rectangle.mk x y (x + w) (y + h)
  let r2 := Rectangle.mk (x + w) y (x + w + 1) (y + h)
  is_rectangles_overlap r1 r2 = false := by
  sorry

theorem touching_top_no_overlap {x y w h : Int}
  (hw : w > 0) (hh : h > 0) :
  let r1 := Rectangle.mk x y (x + w) (y + h)
  let r2 := Rectangle.mk x (y + h) (x + w) (y + h + 1)
  is_rectangles_overlap r1 r2 = false := by
  sorry
