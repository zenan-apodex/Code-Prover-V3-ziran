import Mathlib

def scramble (text : String) (indices : List Int) : String := sorry

theorem scramble_length_preserved 
  (text : String) 
  (indices : List Int) 
  (h1 : text.length > 0) :
  (scramble text indices).length = text.length := sorry

theorem scramble_chars_same_sorted
  (text : String)
  (indices : List Int)
  (h1 : text.length > 0) :
  String.toList (scramble text indices) = String.toList text := sorry
