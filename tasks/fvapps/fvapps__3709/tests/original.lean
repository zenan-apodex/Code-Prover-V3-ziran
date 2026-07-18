import Mathlib

def simple_multiplication (n : Int) : Int := sorry

theorem simple_multiplication_even (n : Int) 
  (h : n % 2 = 0) : 
  simple_multiplication n = n * 8 := sorry

theorem simple_multiplication_odd (n : Int)
  (h : n % 2 = 1) :
  simple_multiplication n = n * 9 := sorry
