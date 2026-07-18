import Mathlib

def infected_zeroes (arr : List Nat) : Nat := sorry





theorem infected_zeroes_singleton_zero (arr : List Nat)
  (h : arr = [0]) :
  infected_zeroes arr = 0 := sorry

theorem infected_zeroes_singleton_one (arr : List Nat)
  (h : arr = [1]) :
  infected_zeroes arr = 1 := sorry
