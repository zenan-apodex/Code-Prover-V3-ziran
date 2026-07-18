import Mathlib

def to_goat_latin (s : String) : String := sorry

def splitString (s : String) : List String := sorry

theorem to_goat_latin_preserves_word_count {s : String} :
  (splitString s).length = (splitString (to_goat_latin s)).length := sorry

def getStringAt (words : List String) (i : Nat) : String := sorry

def endsWith (s : String) (suffix : String) : Bool := sorry

theorem to_goat_latin_ma_suffix_rule {s : String} (i : Nat) (h : i < (splitString s).length) :
  let result := splitString (to_goat_latin s)
  let suffix := "ma" ++ String.mk (List.replicate (i+1) 'a')
  endsWith (getStringAt result i) suffix := sorry

def dropRight (s : String) (n : Nat) : String := sorry
def firstChar (s : String) : Char := sorry
def dropFirst (s : String) : String := sorry

theorem to_goat_latin_vowel_rule {s : String} (i : Nat) (h : i < (splitString s).length) :
  let orig := splitString s
  let result := splitString (to_goat_latin s)
  let orig_word := getStringAt orig i
  let transformed := dropRight (getStringAt result i) (2 + (i+1))
  if (firstChar orig_word).toLower ∈ ['a', 'e', 'i', 'o', 'u'] then
    transformed = orig_word
  else
    transformed = dropFirst orig_word ++ String.mk [firstChar orig_word] := sorry 

def countChar (s : String) (c : Char) : Nat := sorry

theorem to_goat_latin_trailing_a_count {s : String} (i : Nat) (h : i < (splitString s).length) :
  let result := splitString (to_goat_latin s)
  countChar (getStringAt result i) 'a' ≥ i + 1 := sorry
