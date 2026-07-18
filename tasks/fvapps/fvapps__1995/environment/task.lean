import Mathlib

structure Trip where
  passengers : Int
  startLoc : Int
  endLoc : Int
deriving Repr

def carPooling (trips : List Trip) (capacity : Int) : Bool :=
  sorry

theorem capacity_zero (trips : List Trip) :
  carPooling trips 0 = (trips.length = 0) :=
  sorry

theorem timeline_under_capacity (trips : List Trip) (capacity : Int) :
  carPooling trips capacity = true →
  ∀ t : Int, 
    (trips.foldl (λ acc trip =>
      if t ≥ trip.startLoc ∧ t < trip.endLoc
      then acc + trip.passengers 
      else acc) 0) ≤ capacity :=
  sorry

theorem large_capacity_always_works (trips : List Trip) :
  carPooling trips 1000000 = true :=
  sorry

theorem timeline_consistency (trips : List Trip) :
  (trips.foldl (λ acc trip => acc + trip.passengers - trip.passengers) 0) = 0 :=
  sorry

theorem trip_valid (t : Trip) : 
  t.passengers > 0 ∧ 
  t.passengers ≤ 1000 ∧ 
  t.startLoc ≥ 0 ∧ 
  t.startLoc < 1000 ∧ 
  t.endLoc > 0 ∧ 
  t.endLoc ≤ 1000 ∧ 
  t.startLoc < t.endLoc :=
  sorry
