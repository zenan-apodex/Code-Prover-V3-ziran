import Mathlib

def sum_of_digits (s : String) : Nat :=
  sorry

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + sum xs

theorem sum_of_digits_no_digits (s : String) 
  (h : ∀ c ∈ s.data, !c.isDigit) : 
  sum_of_digits s = 0 := 
  sorry

theorem sum_of_digits_all_digits (digits : List Nat)
  (h : ∀ d ∈ digits, d ≤ 9) :
  sum_of_digits (String.join (digits.map toString)) = List.sum digits := 
  sorry

theorem sum_of_digits_mixed (letters digits : String)
  (h1 : ∀ c ∈ letters.data, !c.isDigit)
  (h2 : ∀ c ∈ digits.data, c.isDigit) :
  sum_of_digits (letters ++ digits) = sum_of_digits digits :=
  sorry
