import Mathlib

def count (c : Char) (s : String) : Nat := sorry
def product (s : String) : Nat := sorry

theorem product_non_negative (s : String) : 
  product s ≥ 0 := sorry

theorem product_commutative (s : String) :
  let swapped := s.replace "!" "?" |>.replace "?" "!"
  product s = product swapped := sorry

theorem product_zero_if_missing_char (s : String) :
  let no_excl := s.replace "!" ""
  let no_quest := s.replace "?" "" 
  product no_excl = 0 ∧ product no_quest = 0 := sorry
