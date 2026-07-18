import Mathlib

def splitSentence (s : String) : List String := sorry

theorem split_sentence_rejoin (s : String) : 
  String.intercalate " " (splitSentence s) = String.intercalate " " (s.split (· = ' ')) := sorry

theorem split_sentence_nonempty_parts (s : String) :
  ∀ part ∈ splitSentence s, part.length > 0 := sorry

theorem split_sentence_no_whitespace (s : String) :
  ∀ part ∈ splitSentence s, ' ' ∉ part.data := sorry
