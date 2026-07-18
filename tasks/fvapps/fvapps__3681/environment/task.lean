import Mathlib

def Base := String 
def convert_num (n : Int) (b : Base) : String := sorry

theorem valid_conversion_hex (n : Int) :
  convert_num n "hex" = s!"0x{n}" := sorry

theorem valid_conversion_bin (n : Int) :
  convert_num n "bin" = s!"0b{n}" := sorry

theorem invalid_base (n : Int) (b : Base) :
  b ≠ "hex" → b ≠ "bin" → 
  convert_num n b = "Invalid base input" := sorry

theorem invalid_number_type (s : String) (b : Base) :
  convert_num 0 b = "Invalid number input" := sorry
