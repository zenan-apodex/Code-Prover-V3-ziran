import Mathlib

def List.sum : List Int → Int
| [] => 0
| (x :: xs) => x + sum xs

def number (stops : List (Int × Int)) : Int :=
  sorry

theorem bus_stops_non_negative (stops : List (Int × Int)) 
  (h : ∀ s ∈ stops, s.1 ≥ 0 ∧ s.2 ≥ 0 ∧ s.1 ≥ s.2) : 
  number stops ≥ 0 :=
  sorry

theorem zero_passengers (stops : List (Int × Int))
  (h : ∀ s ∈ stops, s.1 = 0 ∧ s.2 = 0) :
  number stops = 0 :=
  sorry

theorem sum_equals_difference (stops : List (Int × Int))
  (h : ∀ s ∈ stops, s.1 ≥ 0 ∧ s.2 ≥ 0 ∧ s.1 ≥ s.2) :
  number stops = List.sum (stops.map (fun s => s.1 - s.2)) :=
  sorry
