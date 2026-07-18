import Mathlib

def String.sillycase (s : String) : String := sorry

theorem sillycase_preserves_length (s : String) :
  s.length > 0 → String.length (s.sillycase) = String.length s := sorry

theorem sillycase_preserves_chars (s : String) :
  s.length > 0 → String.toLower (s.sillycase) = String.toLower s := sorry

theorem sillycase_first_half (s : String) (h : s.length > 0) :
  let half := (s.length + 1) / 2;
  String.toLower (String.take (s.sillycase) half) = String.toLower (String.take s half) := sorry

theorem sillycase_second_half (s : String) (h : s.length > 0) :
  let half := (s.length + 1) / 2;
  String.toUpper (String.drop (s.sillycase) half) = String.toUpper (String.drop s half) := sorry
