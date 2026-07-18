import Mathlib

def morse_converter (s : String) : Nat :=
  sorry

def convertToMorse (n : Nat) : String :=
  sorry

theorem morse_converter_output_valid (s : String) :
  let result := morse_converter s
  result ≥ 0
  := sorry
