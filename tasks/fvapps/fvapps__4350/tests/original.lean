import Mathlib

def pre_fizz (n : Nat) : List Nat :=
  sorry

theorem pre_fizz_returns_sequential_integers (n : Nat) (h : n > 0) : 
  pre_fizz n = List.range' 1 n := sorry

theorem pre_fizz_length (n : Nat) (h : n > 0) :
  (pre_fizz n).length = n := sorry 

theorem pre_fizz_elements_increasing (n : Nat) (h : n > 0) :
  ∀ i : Nat, i < (pre_fizz n).length - 1 → 
    (pre_fizz n)[i]! < (pre_fizz n)[i+1]! := sorry
