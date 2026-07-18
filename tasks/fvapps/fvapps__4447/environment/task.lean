import Mathlib

def revamp (s : String) : String := sorry

def sumChars (s : String) : Nat := sorry

def sortString (s : String) : String := sorry



theorem output_has_same_word_count (s : String) :
  (String.split (revamp s) (· = ' ')).length = (String.split s (· = ' ')).length := sorry 



theorem words_internally_sorted (s : String) :
  let result := String.split (revamp s) (· = ' ')
  ∀ word, word ∈ result → 
    word = sortString word := sorry



theorem empty_string :
  revamp "" = "" := sorry
