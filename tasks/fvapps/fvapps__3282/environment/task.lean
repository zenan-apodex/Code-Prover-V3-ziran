import Mathlib

def how_many_times (annual_price individual_price : Nat) : Nat :=
  sorry

theorem how_many_times_positive
  (annual_price individual_price : Nat)
  (h1 : annual_price > 0)
  (h2 : individual_price > 0) :
  how_many_times annual_price individual_price > 0 :=
  sorry

theorem how_many_times_covers_annual
  (annual_price individual_price : Nat) 
  (h1 : annual_price > 0)
  (h2 : individual_price > 0) :
  (how_many_times annual_price individual_price) * individual_price ≥ annual_price :=
  sorry

theorem how_many_times_minimal
  (annual_price individual_price : Nat)
  (h1 : annual_price > 0) 
  (h2 : individual_price > 0) :
  ((how_many_times annual_price individual_price) - 1) * individual_price < annual_price :=
  sorry

theorem how_many_times_equal_prices
  (price : Nat)
  (h : price > 0) :
  how_many_times price price = 1 :=
  sorry
