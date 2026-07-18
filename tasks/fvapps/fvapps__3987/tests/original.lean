import Mathlib

def reverseString (s : String) : String := sorry

def spinWords (s : String) : String := sorry

theorem spin_words_length_five_or_more {word : String} 
  (h : word.length ≥ 5) : 
  spinWords word = reverseString word := sorry

theorem spin_words_length_less_than_five {word : String} 
  (h : word.length < 5) : 
  spinWords word = word := sorry

theorem spin_words_preserves_length (word : String) :
  (spinWords word).length = word.length := sorry

theorem spin_words_empty : 
  spinWords "" = "" := sorry
