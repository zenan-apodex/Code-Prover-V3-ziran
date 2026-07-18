import Mathlib

def next_happy_year (year : Nat) : Nat := sorry

-- Helper functions
def number_to_digits (n : Nat) : List Nat := sorry 
def count_unique (l : List Nat) : Nat := sorry

theorem next_happy_year_increases (year : Nat) 
  (h : year ≥ 1000 ∧ year ≤ 8999) :
  next_happy_year year > year := sorry
