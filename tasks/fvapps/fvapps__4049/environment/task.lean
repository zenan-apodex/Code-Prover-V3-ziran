import Mathlib

def monkey_count (n : Nat) : List Nat := sorry

theorem monkey_count_length {n : Nat} (h : n > 0) : 
  (monkey_count n).length = n := sorry

theorem monkey_count_first {n : Nat} (h : n > 0) :
  (monkey_count n).head! = 1 := sorry 

theorem monkey_count_last {n : Nat} (h : n > 0) :
  (monkey_count n).getLast! = n := sorry
