import Mathlib

def swap (s : String) : String := sorry

def is_ascii_letter (c : Char) : Bool := sorry

theorem swap_preserves_non_letters (s : String)
  (h : ∀ c, c ∈ s.data → ¬is_ascii_letter c) :
  swap s = s := sorry

theorem swap_changes_ascii_letters (s : String)
  (h : ∀ c, c ∈ s.data → is_ascii_letter c) :
  ∀ i : Fin s.length,
  s.get (String.Pos.mk i) ≠ (swap s).get (String.Pos.mk i) := sorry

theorem swap_preserves_length (s : String) :
  (swap s).length = s.length := sorry
