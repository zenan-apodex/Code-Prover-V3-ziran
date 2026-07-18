import Mathlib

def largest_sum (s : String) : Nat :=
  sorry

theorem empty_and_zero :
  largest_sum "" = 0 ∧
  largest_sum "0" = 0 ∧
  largest_sum "00" = 0 := sorry



theorem repeated_digit_sum (n : Nat) (d : Nat) 
  (h1 : n > 0) (h2 : n ≤ 10) (h3 : d > 0) (h4 : d ≤ 9) :
  largest_sum (String.join (List.replicate n (toString d))) = n * d := sorry
