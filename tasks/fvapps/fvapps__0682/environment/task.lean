import Mathlib

def solve (n : Nat) (seq : List Nat) : Nat × Nat := sorry

def isValidAfterReverse (seq : List Nat) (l r : Nat) : Bool := sorry

theorem solve_sorted_sequence {n : Nat} (h : n > 0) :
  let seq := List.range' 1 n
  solve n seq = (0, 0) := sorry

theorem solve_reversed_sequence {n : Nat} (h : n > 1) :
  let seq := List.reverse (List.range' 1 n) 
  solve n seq = (1, n) := sorry
