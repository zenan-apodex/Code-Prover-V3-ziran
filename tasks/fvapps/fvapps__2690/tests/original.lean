import Mathlib

def remove_parentheses (s : String) : String :=
  sorry

theorem string_without_parens_unchanged (s : String)
  (h : ∀ c ∈ s.data, c ≠ '(' ∧ c ≠ ')') :
  remove_parentheses s = s :=
sorry

theorem nested_parens_give_empty_string (texts : List String)
  (h₁ : texts ≠ [])
  (h₂ : ∀ s ∈ texts, ∀ c ∈ s.data, c ≠ '(' ∧ c ≠ ')') :
  remove_parentheses (String.join (texts.map (fun s => "(" ++ s ++ ")"))) = "" :=
sorry

theorem balanced_parens_give_empty_string_1 :
  remove_parentheses "(())" = "" :=
sorry

theorem balanced_parens_give_empty_string_2 :
  remove_parentheses "((()))" = "" :=
sorry
