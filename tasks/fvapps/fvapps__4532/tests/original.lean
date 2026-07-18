import Mathlib

def validate_code {α} (x : α) : Bool :=
sorry

theorem validate_code_ints (code : Int) :
  validate_code code = String.startsWith (toString code) "123" :=
sorry

theorem validate_code_strings (code : String) :
  validate_code code = String.startsWith code "123" :=
sorry

theorem validate_code_string_numbers (code : String) :
  validate_code code = String.startsWith code "123" :=
sorry

theorem validate_code_empty :
  validate_code "" = false :=
sorry

theorem validate_code_none (α : Type) :
  validate_code (none : Option α) = false :=
sorry

theorem validate_code_true :
  validate_code true = false :=
sorry 

theorem validate_code_false :
  validate_code false = false :=
sorry

theorem validate_code_float (f : Float) :
  validate_code f = String.startsWith (toString f) "123" :=
sorry
