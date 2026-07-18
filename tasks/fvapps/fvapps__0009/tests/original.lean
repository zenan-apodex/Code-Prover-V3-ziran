import Mathlib

def count_alice_score (s : String) : Nat :=
  sorry

theorem result_not_exceed_input_length 
  (s : String) : 
  count_alice_score s ≤ s.length := 
  sorry

theorem result_nonnegative
  (s : String) :
  count_alice_score s ≥ 0 :=
  sorry

def countOnes (s : String) : Nat :=
  sorry



theorem empty_or_zeros_returns_zero
  (s : String) :
  (s.isEmpty ∨ s.all (· = '0')) → count_alice_score s = 0 :=
  sorry

def sortByLengthDesc (ls : List String) : List String :=
  sorry

def getAlternateSum (ls : List String) : Nat :=
  sorry



theorem all_ones_full_score
  (s : String) :
  s.all (· = '1') →
  s.length > 0 →
  count_alice_score s = s.length :=
  sorry
