import Mathlib

def is_letter (s : String) : Bool := sorry

theorem letter_length_check : 
  ∀ s : String, s.length ≠ 1 → ¬(is_letter s) := sorry

theorem letter_matches_ascii (s : String) (h: s.length = 1):
  is_letter s = s.data[0]!.isAlpha := sorry

theorem letters_are_letters :
  ∀ c : Char, c.isAlpha → is_letter c.toString := sorry
