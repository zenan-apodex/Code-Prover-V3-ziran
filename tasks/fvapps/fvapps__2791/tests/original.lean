import Mathlib

def trigrams (s : String) : String := sorry 

def stringToGrams (s : String) : List String := sorry

theorem trigrams_empty_if_short (s : String) :
  s.length < 3 → trigrams s = "" := sorry 

theorem trigrams_length (s : String) :
  s.length ≥ 3 → 
  let res := trigrams s
  res ≠ "" →
  (stringToGrams res).length = s.length - 2 := sorry

theorem trigrams_no_spaces_in_grams (s : String) :
  let res := trigrams s
  let grams := stringToGrams res
  ∀ g ∈ grams, ¬ g.contains ' ' := sorry
