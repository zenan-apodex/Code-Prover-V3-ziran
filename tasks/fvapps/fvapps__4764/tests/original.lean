import Mathlib

structure Matrix where
  content : List String
  deriving Repr

def rotate_clockwise (m : Matrix) : Matrix :=
  sorry

theorem empty_matrix_rotation :
  ∀ (m : Matrix), m.content = [] → (rotate_clockwise m).content = [] :=
  sorry

theorem rotation_dimensions {m : Matrix} (h1 : m.content ≠ []) 
    (h2 : ∃ s, m.content.head? = some s) (h3 : ∀ s, m.content.head? = some s → s ≠ "") :
    let rotated := rotate_clockwise m
    let first := Classical.choose h2
    (rotated.content.length = first.length) ∧
    (∀ (row : String), row ∈ rotated.content → row.length = m.content.length) :=
  sorry

theorem four_rotations_identity {m : Matrix} (h1 : m.content ≠ [])
    (h2 : ∃ s, m.content.head? = some s) (h3 : ∀ s, m.content.head? = some s → s ≠ "") :
    rotate_clockwise (rotate_clockwise (rotate_clockwise (rotate_clockwise m))) = m :=
  sorry

def manual_rotate (m : Matrix) : Matrix :=
  sorry

theorem rotation_equals_manual :
  ∀ (m : Matrix), rotate_clockwise m = manual_rotate m :=
  sorry
