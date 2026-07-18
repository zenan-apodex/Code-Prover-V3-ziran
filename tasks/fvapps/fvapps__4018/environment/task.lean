import Mathlib

def isDigit (s : String) : Bool :=
  sorry

def String.toFloat? (s : String) : Option Float :=
  sorry

theorem valid_float_strings (f : Float) : 
  isDigit (toString f) = true :=
  sorry

theorem arbitrary_text (s : String) :
  match s.toFloat? with
  | some _ => isDigit s = true  
  | none => isDigit s = false
  :=
  sorry

theorem whitespace_padding (s : String) (f : Float) :
  isDigit (s ++ toString f ++ s) = true := 
  sorry

theorem edge_cases :
  isDigit "" = false ∧ 
  isDigit " " = false ∧
  isDigit "-0" = true ∧
  isDigit "+0" = true ∧
  isDigit "-.1" = true ∧
  isDigit "+.1" = true :=
  sorry
