import Mathlib

def countSpaces (s : String) : Nat :=
  sorry

def split (s : String) : List String :=
  sorry

def startsWith (s : String) (c : Char) : Bool :=
  sorry

def reorderSpaces (s : String) : String :=
  sorry

theorem reorderSpaces_preserves_spaces (s : String) :
  countSpaces s = countSpaces (reorderSpaces s) := by
  sorry

theorem reorderSpaces_preserves_words (s : String) :
  split s = split (reorderSpaces s) := by
  sorry

theorem reorderSpaces_no_leading_spaces (s : String) :
  ¬startsWith (reorderSpaces s) ' ' := by
  sorry
