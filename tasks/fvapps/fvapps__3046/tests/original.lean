import Mathlib

def thue_morse (n : Nat) : String := sorry

/-- The length of thue_morse(n) equals n and contains only 0's and 1's -/
theorem thue_morse_length (n : Nat) : 
  (thue_morse n).length = n ∧ 
  ∀ p : String.Pos, 
    String.contains "01" ((thue_morse n).get p) := sorry

/-- Any longer sequence starts with the shorter sequence -/
theorem thue_morse_prefix_consistency (n : Nat) :
  (thue_morse (n + 1)).take n = thue_morse n := sorry

/-- If n > 0, the sequence starts with 0 -/
theorem thue_morse_starts_correct (n : Nat) (h : n > 0) :
  ∃ p : String.Pos, (thue_morse n).get p = '0' := sorry
