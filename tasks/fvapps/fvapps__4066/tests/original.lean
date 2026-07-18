import Mathlib

def string_to_array (s : String) : Array String := sorry

theorem string_to_array_split_join
  (words : Array String)
  (h₁ : words.size > 0)
  (h₂ : ∀ (i : Fin words.size), words.get i ≠ "") :
  string_to_array (" ".intercalate words.toList) = words := sorry

theorem string_to_array_empty :
  string_to_array "" = #[""] := sorry

theorem string_to_array_no_empty_elements
  (s : String)
  (h : s ≠ "")
  (i : Nat)
  (h₂ : i < (string_to_array s).size - 1) :
  ∃ h₃ : i < (string_to_array s).size, 
    (string_to_array s).get ⟨i, h₃⟩ ≠ "" := sorry
