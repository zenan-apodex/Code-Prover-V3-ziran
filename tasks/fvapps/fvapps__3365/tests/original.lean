import Mathlib

def format_poem (s : String) : String := sorry

theorem format_poem_single_sentence (text : String) 
  (h : ¬ (text.contains '.' )) : 
  format_poem text = text ++ "." := sorry

theorem format_poem_basic_sentences :
  format_poem "First sentence. Second sentence. Third sentence" = 
  "First sentence.\nSecond sentence.\nThird sentence." := sorry
