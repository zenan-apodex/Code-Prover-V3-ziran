import Mathlib

def find_anagram_pairs (s : String) : Nat :=
  sorry

def reverseString (s : String) : String :=
  sorry

theorem find_anagram_pairs_nonneg (s : String) :
  find_anagram_pairs s ≥ 0 := 
  sorry

theorem find_anagram_pairs_empty_or_single (s : String) : 
  s.length ≤ 1 → find_anagram_pairs s = 0 :=
  sorry
