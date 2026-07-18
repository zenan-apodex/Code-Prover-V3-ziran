import Mathlib

def unlucky_number (n : Nat) : Nat :=
  sorry

theorem unlucky_number_non_negative (n : Nat) :
  unlucky_number n ≥ 0 :=
  sorry

def containsChar (s : String) (c : Char) : Bool :=
  s.any (fun x => x == c)

def isDivisibleBy13AndNoUnluckyDigits (i : Nat) : Bool :=
  i % 13 == 0 && 
  !containsChar (toString i) '4' && 
  !containsChar (toString i) '7'



theorem unlucky_number_zero :
  unlucky_number 0 = 1 :=
  sorry

theorem unlucky_number_twelve :
  unlucky_number 12 = 1 :=
  sorry

theorem unlucky_number_thirteen :
  unlucky_number 13 = 2 :=
  sorry
