import Mathlib

namespace PostalCode

def validate_postal_code (s : String) : Bool := sorry

theorem invalid_format_postal_code {s : String} :
  (¬ s.all Char.isDigit) ∨ (s.length ≠ 6) ∨ (s.data[0]! = '0') →
  validate_postal_code s = false := sorry

theorem valid_format_postal_codes {s : String} 
  (h₁ : s.length = 6)
  (h₂ : s.all Char.isDigit) 
  (h₃ : s.data[0]! ≠ '0') :
  validate_postal_code s = 
    ¬ (∃ i : Fin 4, ∃ j : Fin 4, i ≠ j ∧ 
       s.data[i.val]! = s.data[(i.val + 2)]! ∧
       s.data[j.val]! = s.data[(j.val + 2)]!) := sorry

end PostalCode
