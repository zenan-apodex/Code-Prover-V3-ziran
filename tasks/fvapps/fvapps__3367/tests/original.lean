import Mathlib

def routes (n : Int) : Int := sorry

def factorial (n : Int) : Int := sorry

theorem routes_formula {n : Int} (h : n > 0) : 
  routes n = factorial (2*n) / (factorial n * factorial n) := sorry

theorem routes_non_positive {n : Int} (h : n ≤ 0) :
  routes n = 0 := sorry

theorem routes_monotonic {n : Int} (h1 : n > 1) :
  routes n > routes (n-1) := sorry 

theorem routes_initial_values :
  routes 1 = 2 ∧ routes 2 = 6 ∧ routes 3 = 20 := sorry
