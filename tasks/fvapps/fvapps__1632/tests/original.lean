import Mathlib

def countOnes (a b : Nat) : Nat := sorry

def toBinary (n : Nat) : List Nat := sorry

def countBinaryOnes (n : Nat) : Nat := sorry

theorem countOnes_non_negative
  (a b : Nat)
  (h1 : 0 < a) (h2 : a ≤ 10^6)
  (h3 : 0 < b) (h4 : b ≤ 10^6) :
  0 ≤ countOnes a b :=
sorry
