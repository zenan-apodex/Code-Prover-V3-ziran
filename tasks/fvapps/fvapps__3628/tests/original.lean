import Mathlib

universe u

def rotate {α : Type u} (arr : List α) (n : Int) : List α :=
  sorry

theorem rotate_empty {α : Type u} (n : Int) :
  rotate ([] : List α) n = ([] : List α) :=
  sorry

theorem rotate_length {α : Type u} (arr : List α) (n : Int) :
  arr ≠ [] → List.length (rotate arr n) = List.length arr :=
  sorry

theorem rotate_elements_same {α : Type u} (arr : List α) (n : Int) (x : α) :
  arr ≠ [] → (x ∈ arr ↔ x ∈ rotate arr n) :=
  sorry

theorem rotate_period {α : Type u} (arr : List α) :
  arr ≠ [] → rotate arr (List.length arr) = arr :=
  sorry

theorem rotate_split {α : Type u} (arr : List α) (n : Int) :
  arr ≠ [] →
  let normalized := Int.mod n (List.length arr)
  rotate arr n = arr.drop (List.length arr - normalized.toNat) ++ arr.take (List.length arr - normalized.toNat) :=
  sorry

theorem rotate_compose {α : Type u} (arr : List α) (n1 n2 : Int) :
  arr ≠ [] →
  rotate (rotate arr n1) n2 = rotate arr (Int.mod (n1 + n2) (List.length arr)) :=
  sorry

theorem rotate_inverse {α : Type u} (arr : List α) (n : Int) :
  arr ≠ [] →
  rotate (rotate arr n) (-n) = arr :=
  sorry
