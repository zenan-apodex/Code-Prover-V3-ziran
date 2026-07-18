import Mathlib

def decode_string (s : String) : Nat := sorry





theorem decode_string_empty :
  decode_string "" = 0 := sorry

theorem decode_string_single_zero :
  decode_string "0" = 0 := sorry

theorem decode_string_leading_zero :
  decode_string "01" = 0 := sorry

theorem decode_string_single_digit {d : Char} 
  (h1 : d.isDigit)
  (h2 : d ≠ '0') :
  decode_string (String.mk [d]) = 1 := sorry

theorem decode_string_twelve :
  decode_string "12" = 2 := sorry

theorem decode_string_226 :
  decode_string "226" = 3 := sorry

theorem decode_string_eleven :
  decode_string "11" = 2 := sorry
