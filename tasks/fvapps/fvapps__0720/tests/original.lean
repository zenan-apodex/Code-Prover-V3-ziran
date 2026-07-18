import Mathlib

def String.isBinaryString (s : String) : Bool := s.all (fun c => c == '0' || c == '1')

def count_special_substrings (s : String) : Nat :=
  sorry





theorem count_special_substrings_all_zeros (s : String) 
    (h : s.all (· = '0') = true) :
    count_special_substrings s = 0 :=
  sorry
