import Mathlib

def count_odd_squares (n : Int) : Int := sorry

theorem count_odd_squares_positive (n : Int) : 
  n > 0 → count_odd_squares n > 0 := sorry

theorem count_odd_squares_odd_numbers (n : Int) (hn : n > 0) :
  n % 2 = 1 → count_odd_squares n = Nat.sum (List.filter (fun i => i % 2 = 1) (List.range (n.toNat))) := sorry

theorem count_odd_squares_monotonic (n : Int) :
  n > 1 → count_odd_squares n > count_odd_squares (n-1) := sorry

theorem count_odd_squares_nonpositive (n : Int) :
  n ≤ 0 → count_odd_squares n = 0 := sorry
