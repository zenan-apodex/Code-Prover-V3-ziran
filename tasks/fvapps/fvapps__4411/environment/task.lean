import Mathlib

def find_missing_number (nums : List Nat) : Nat := sorry

theorem find_missing_number_sequence (n : Nat) (h : 0 < n) (h2 : n ≤ 1000) : 
  let nums := (List.range n).map (· + 1)
  let nums_without_last := nums.dropLast
  find_missing_number nums_without_last = n := sorry
