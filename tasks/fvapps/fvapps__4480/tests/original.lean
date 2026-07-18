import Mathlib

def parse (s : String) : List Int := sorry

def countChar (s : String) (c : Char) : Nat := 
  s.toList.filter (· = c) |>.length



theorem parse_output_bounded (s : String) :
  ∀ x ∈ parse s, x ≥ -s.length
  := sorry
