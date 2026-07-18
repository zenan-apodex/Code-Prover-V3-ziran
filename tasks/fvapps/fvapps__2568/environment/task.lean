import Mathlib

def count_distinct_stamps (stamps : List String) : Nat := sorry

theorem count_distinct_stamps_bounded (stamps : List String) : 
  count_distinct_stamps stamps ≤ stamps.length := sorry

theorem count_distinct_stamps_nonnegative (stamps : List String) :
  count_distinct_stamps stamps ≥ 0 := sorry 

def count_unique (l : List String) : Nat := sorry



theorem count_distinct_stamps_deterministic (stamps : List String) : 
  count_distinct_stamps stamps = count_distinct_stamps stamps := sorry

theorem count_distinct_stamps_with_duplicates (stamps : List String) :
  count_distinct_stamps (stamps ++ stamps) = count_distinct_stamps stamps := sorry

theorem count_distinct_stamps_empty :
  count_distinct_stamps [] = 0 := sorry
