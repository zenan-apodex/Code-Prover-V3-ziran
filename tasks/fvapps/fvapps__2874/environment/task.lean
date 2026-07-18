import Mathlib

def my_parse_int (s : String) : String ⊕ Int := sorry

theorem valid_integer_string (s : String) (h : ∀ c ∈ s.data, c.isDigit) : 
  my_parse_int s = Sum.inr (String.toInt! s) := sorry

theorem padded_integer_string (s : String) (n : Int) 
  (h : String.toInt! (String.trim s) = n) :
  my_parse_int s = Sum.inr n := sorry

theorem invalid_string (s : String) 
  (h : ∃ c ∈ s.data, ¬c.isDigit ∧ ¬c.isWhitespace) :
  my_parse_int s = Sum.inl "NaN" := sorry

theorem arbitrary_string (s : String) :
  (my_parse_int s = Sum.inl "NaN") ∨ 
  (my_parse_int s = Sum.inr (String.toInt! (String.trim s))) := sorry
