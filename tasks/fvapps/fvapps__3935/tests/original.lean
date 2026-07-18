import Mathlib

def isVowel (c : Char) : Bool := sorry

def vowel_recognition (s : String) : Nat := sorry

theorem vowel_recognition_is_natural (s : String) :
  vowel_recognition s ≥ 0 :=
sorry





theorem case_insensitive (s : String) :
  vowel_recognition s.toUpper = vowel_recognition s.toLower :=
sorry
