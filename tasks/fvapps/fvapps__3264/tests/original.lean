import Mathlib

def count (n : Int) : Int := sorry

theorem count_monotonic {n : Int} (h : n ≥ 5) : 
  count n ≥ count (n-1) := sorry

theorem count_negative_input {n : Int} (h : n < 0) : 
  count n = sorry := sorry
