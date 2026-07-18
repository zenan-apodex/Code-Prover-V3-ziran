import Mathlib

structure Token where
  text : String 
  type : String

def Simplexer : Type := String → List Token
def empty : Simplexer := sorry
def scan : String → Token := sorry

theorem empty_simplexer : 
  empty "" = [] := sorry

theorem integer_token :
  scan "123" = ⟨"123", "integer"⟩ := sorry

theorem identifier_token :
  scan "abc" = ⟨"abc", "identifier"⟩ := sorry

theorem keyword_token :
  scan "if" = ⟨"if", "keyword"⟩ := sorry

theorem whitespace_token :
  scan " " = ⟨" ", "whitespace"⟩ := sorry

theorem operator_token :
  scan "+" = ⟨"+", "operator"⟩ := sorry

theorem boolean_token :
  scan "true" = ⟨"true", "boolean"⟩ := sorry
